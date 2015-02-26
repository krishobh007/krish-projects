class Account < ActiveRecord::Base
  attr_accessible :account_type, :account_type_id, :account_name, :account_number, :hotel_chain_id,
                  :contact_first_name, :contact_last_name, :contact_job_title, :contact_email, :contact_phone, :ar_number,
                  :billing_information, :web_page, :address_attributes, :emails_attributes, :phones_attributes

  validates :account_name, :hotel_chain_id, presence: true

  validates :account_number, allow_blank: true, uniqueness: { scope: [:account_type_id, :hotel_chain_id], case_sensitive: false }

  validates :contact_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }, allow_nil: true

  has_one :logo, class_name: 'Image', as: :image_attachable
  has_one :ar_detail, class_name: 'ArDetail'
  has_many :payment_methods, :as => :associated
  has_many :rates
  has_many :default_account_routings
  belongs_to :hotel_chain
  has_enumerated :account_type, class_name: 'Ref::AccountType'

  has_many :company_reservations, class_name: 'Reservation', foreign_key: :company_id
  has_many :travel_agent_reservations, class_name: 'Reservation', foreign_key: :travel_agent_id

  has_one :address, class_name: 'Address', as: :associated_address
  has_many :emails, class_name: 'AdditionalContact', as: :associated_address, conditions: { contact_type_id: Ref::ContactType[:EMAIL] }
  has_many :phones, class_name: 'AdditionalContact', as: :associated_address, conditions: { contact_type_id: Ref::ContactType[:PHONE] }
  has_many :bills
  has_many :ar_transactions

  accepts_nested_attributes_for :address, :emails, :phones,  allow_destroy: true
  
  scope :company_cards,->{with_account_type(:COMPANY)}
  scope :travel_agents,->{with_account_type(:TRAVELAGENT)}

  scope :find_account, lambda { |params|
    results = scoped.includes(:address).includes(:phones)

    if params[:query].present?
      search_fields = %w(account_name account_number addresses.city)
      search_conditions = search_fields.map { |field| "upper(#{field}) like :query" }.join(' OR ')
      results = results.where(search_conditions, query: "%#{params[:query].upcase}%")
    end

    if params[:name].present?
      results = results.where('upper(account_name) like :value ', value: "%#{params[:name]}%")
    end

    results = results.where('upper(account_number) like :value', value: "%#{params[:account_number]}%") if params[:account_number].present?
    results = results.where('upper(addresses.city) like :value', value: "%#{params[:city]}%") if params[:city].present?
    results = results.where('upper(addresses.state) like :value', value: "%#{params[:state]}%") if params[:state].present?
    results = results.where('upper(addresses.postal_code) like :value', value: "%#{params[:postal_code]}%") if params[:postal_code].present?
    results = results.where('upper(additional_contacts.value) like :value', value: "%#{params[:phone]}%") if params[:phone].present?

    results = results.order(:account_name)
  }

  def ar_reservations(hotel_id)
    ar_transactions.where(hotel_id: hotel_id).where('debit IS NOT NULL').joins("INNER JOIN reservations ON ar_transactions.reservation_id = reservations.id AND reservations.status_id = #{Ref::ReservationStatus[:CHECKEDOUT].id}")
        .joins('INNER JOIN reservation_daily_instances ON reservation_daily_instances.reservation_id = reservations.id')
        .joins('LEFT OUTER JOIN rooms ON reservation_daily_instances.room_id = rooms.id')
        .joins('INNER JOIN reservations_guest_details ON reservations_guest_details.reservation_id = reservations.id AND reservations_guest_details.is_primary = 1')
        .joins('INNER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id')
        .select('reservations.arrival_date,reservations.arrival_time, reservations.dep_date,reservations.departure_time, reservations.confirm_no, ar_transactions.*, guest_details.first_name, guest_details.last_name, guest_details.is_vip, guest_details.id as guest_id, rooms.id as room_id, rooms.room_no')
  end

  def available_credits(hotel)
    self.ar_transactions.where(hotel_id: hotel.id).sum(:credit)
  end

  def amount_owing(hotel)
    self.ar_transactions.where(hotel_id: hotel.id).unpaid.sum(:debit) - self.available_credits(hotel)
  end

  def save_account(params)
    attributes = {
      address_attributes: {},
      emails_attributes: [],
      phones_attributes: []
    }
    [:account_name, :account_number, :billing_information, :web_page, :contact_first_name,
     :contact_last_name, :contact_job_title, :contact_phone, :contact_email, :hotel_chain_id].each do |key|
      attributes[key] = params[:primary_contact_details][key] if params[:primary_contact_details] && params[:primary_contact_details].key?(key)
      attributes[key] = params[:account_details][key] if params[:account_details] &&  params[:account_details].key?(key)
    end
    [:street1, :street2, :street3, :city, :state, :country_id, :postal_code].each do |key|
      attributes[:address_attributes][key] = params[:address_details][key] if params[:address_details] && params[:address_details].key?(key)
    end
    if params[:address_details]
      if params[:address_details][:email_address].present?
        primary_email = emails.primary.first
        attributes[:emails_attributes] = [{ contact_type: :EMAIL, value: params[:address_details][:email_address], label: :HOME, is_primary: true }]
        attributes[:emails_attributes] = [{ id: primary_email.id, contact_type: :EMAIL, value: params[:address_details][:email_address],
                                            label: :HOME, is_primary: true }]   if primary_email.present?
      end
      if params[:address_details][:phone].present?
        primary_phone  = phones.primary.first
        attributes[:phones_attributes] = [{ contact_type: :PHONE, value: params[:address_details][:phone], label: :HOME, is_primary: true }]
        attributes[:phones_attributes] = [{ id: primary_phone.id, contact_type: :PHONE, value: params[:address_details][:phone],
                                            label: :HOME, is_primary: true }] if primary_phone.present?
      end
    end
    attributes[:address_attributes][:id] = address.id if address
    attributes[:address_attributes][:label] = :BUSINESS
    attributes[:account_type] = (params[:account_type] ==  Setting.account_types[:company]) ?  Ref::AccountType[:COMPANY] : Ref::AccountType[:TRAVELAGENT]
    self.update_attributes!(attributes)
    if  params[:account_details].key?(:company_logo)
      logo_from_base64(params[:account_details][:company_logo])
    end
  end

  def logo_from_base64(base64_data)
    base64_data = base64_data.split('base64,')[1]
    file_name = "logo#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(ActiveSupport::Base64.decode64(base64_data))
    end
    logo_file = File.open(image_path)
    self.logo = Image.new
    self.logo.image = logo_file
    self.logo.save!
    File.delete(image_path)
  end

  # Gets a list of reservations based on whether the type is a company or travel agent
  def reservations
    account_type === :COMPANY ? company_reservations : travel_agent_reservations
  end

  def future_reservations(business_date, current_reservation)
    reservations.with_status(:RESERVED).where('reservations.id != ? and arrival_date >= ?', current_reservation.id, business_date)
  end

  # Gets a count of future reservations that have an arrival date greater to the business date
  def future_reservation_count(business_date, current_reservation)
    future_reservations(business_date, current_reservation).count
  end

  def rate_expired_contracts
    rates.joins('INNER JOIN rates as parent_rate ON parent_rate.id = rates.based_on_rate_id').where('parent_rate.end_date IS NOT NULL AND parent_rate.end_date < rates.end_date').first
  end

  def alert_message
    expired_parent_rate = self.rate_expired_contracts
    if expired_parent_rate.present?
      expired_parent_rate.parent_end_date
      expired_parent_rate.errors.full_messages.first
    end
  end
  
  def attached_payment_method
    payment_method = payment_methods.last
    return {} if payment_method.nil?
    
    return {
      payment_type:             payment_method.payment_type.value,
      payment_type_description: payment_method.payment_type.description,
      card_code:                payment_method.credit_card_type.to_s.downcase,
      card_number:              payment_method.mli_token_display.to_s,
      card_expiry:              payment_method.card_expiry ? payment_method.card_expiry_display : '',
      payment_id:               payment_method.id,
      card_name:                payment_method.card_name,
      is_swiped:                payment_method.is_swiped
    }
  end
end
