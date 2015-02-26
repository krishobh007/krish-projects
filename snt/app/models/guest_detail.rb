require 'open-uri'
class GuestDetail < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :birthday, :company, :external_id,
                  :gender, :id, :image_url, :is_vip, :job_title, :passport_expiry,
                  :passport_no, :title, :user_id, :works_at, :avatar_content_type,
                  :avatar_file_name, :avatar_file_size, :hotel_chain_id, :hotel_chain,
                  :contacts_attributes, :addresses_attributes,
                  :language, :language_id, :is_opted_promotion_email, :nationality

  attr_accessible :avatar

  has_many :notification_infos
  has_many :notification_details
  has_many :reservations_guest_details
  has_many :reservations, through: :reservations_guest_details

  belongs_to :hotel_chain
  has_many :addresses, class_name: 'Address', as: :associated_address
  has_many :emails, class_name: 'AdditionalContact', as: :associated_address, conditions: { contact_type_id: Ref::ContactType[:EMAIL] }
  has_many :phones, class_name: 'AdditionalContact', as: :associated_address, conditions: { contact_type_id: Ref::ContactType[:PHONE] }
  has_many :contacts, class_name: 'AdditionalContact', as: :associated_address
  has_many :memberships, class_name: 'GuestMembership'

  has_many :payment_methods, class_name: 'PaymentMethod', as: :associated
  has_many :credit_cards, class_name: 'PaymentMethod', as: :associated, conditions: { payment_type_id: PaymentType.credit_card.id }
  
  has_many :user_activities, class_name: 'UserActivity', as: :associated_activity
  
  has_many :campaigns_recepients
  has_many :campaigns, through: :campaigns_recepients

  has_and_belongs_to_many :preferences, uniq: true, class_name: 'Feature', join_table: 'guest_features', association_foreign_key: 'feature_id'
  has_enumerated :language, class_name: 'Ref::Language'
  belongs_to :user
  has_one :guest_web_token

  validates :last_name, presence: true
  validates :hotel_chain_id, presence: true
  validates :user_id, uniqueness: true, allow_nil: true

  accepts_nested_attributes_for :contacts, :addresses, allow_destroy: true

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':guest_prefix/Guests/:class/:id/:attachment/:style/:filename',
                             default_url: :get_default_user_avatar

  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # Search Guest in Standalone PMS
  # Search the details based on First Name
  scope :first_name, lambda { |first_name|  where('first_name like :first_name', first_name: "#{first_name}%") }

  # Search the details based on Last Name
  scope :last_name, lambda { |last_name|  where('last_name like :last_name', last_name: "#{last_name}%") }

  # Search the guest details based on City
  scope :city, lambda { |city|  where('addresses.city like :city', city: "%#{city}%") }

  # Search the details based on MemberShip No
  scope :membership_no, lambda { |membership_no|  where('guest_memberships.membership_card_number like :membership_no', membership_no: "%#{membership_no}%") }

  # Search the guest details based on Email
  scope :email, lambda { |email|  where('additional_contacts.value like :email', email: "%#{email}%") }

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def last_first
    [last_name, first_name].compact.join(', ')
  end

  def email
    emails.primary.pluck(:value).first
  end

  def phone
    phones.home.pluck(:value).first
  end

  def mobile
    phones.mobile.pluck(:value).first
  end

  def get_ffps
    memberships.ffp.map { |membership| membership.details_hash }
  end

  def get_hlps(hotel)
    memberships.hlp(hotel).map { |membership| membership.details_hash }
  end

  def current_reservation(hotel_id)
    if hotel_id
      business_date = Hotel.find_by_id(hotel_id).active_business_date
      reservations.where("'#{business_date.to_s(:db)}' BETWEEN arrival_date AND dep_date").first
    else
      nil
    end
  end

  def contact_info
    info = {
      title: title,
      first_name: first_name,
      last_name: last_name,
      passport_number: passport_no,
      email: email,
      phone: phones.home.pluck(:value).first,
      mobile: phones.mobile.pluck(:value).first,
      job_title: job_title,
      birthday: birthday,
      passport_expiry: passport_expiry,
      works_at: works_at,
      is_opted_promotion_email: is_opted_promotion_email
    }

    address = addresses.first
    if address
      info[:street] = address.street1
      info[:city] = address.city
      info[:state] = address.state
      info[:postal_code] = address.postal_code
      info[:country] = address.country_id
    end

    membership = memberships.first
    if membership && membership.membership_level_id.present?
      info[:membership_level] = MembershipLevel.find(membership.membership_level_id).andand.membership_level.to_s
    end

    info
  end

  # Method to return the profile complete status before using Social Lobby
  def get_profile_completed_status
    complete_status = 'true'
    user_address = addresses.first if addresses
    if !avatar_file_name.present? ||  !birthday.present? || !works_at.present? || !job_title.present? || (user_address ? !user_address.city.present? : true)
      complete_status = 'false'
    end
    complete_status
  end

  def set_avatar_from_base64(base64_data)
    file_name = "avatar#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
     file.write(ActiveSupport::Base64.decode64(base64_data))
   end
    avatar = File.open(image_path)
    self.avatar = avatar
    File.delete(image_path)
  end

  def avatar_from_url=(url)
    self.avatar = open(url)
  end

  def update_guest_profile(params, current_hotel)
    # Initialize nested attributes
    attributes = {
      contacts_attributes: [],
      addresses_attributes: []
    }

    # Set user level attributes if the key are present
    [:title, :first_name, :last_name, :passport_no, :passport_expiry, :job_title, :works_at, :is_opted_promotion_email].each do |key|
      attributes[key] = params[key] if params.key?(key)
    end
    attributes[:is_vip] = params[:vip] unless params[:vip].nil?
    # Set birthday in format MM/DD/YYYY if present, otherwise set to null
    attributes[:birthday] = params[:birthday].present? ? Date.strptime(params[:birthday], '%m-%d-%Y') : nil if params.key?(:birthday)

    # If the email is present, insert or update the email on the user contacts
    if params.key?(:email)
      primary_email =  emails.find_by_value(params[:email]) || emails.primary.first
      emails.where('value != ?',primary_email.value).each { |seconday_emails| seconday_emails.update_attribute(:is_primary, false) } if primary_email.present?
      if primary_email
        if params[:email].present?
          attributes[:contacts_attributes] << { id: primary_email.id, value: params[:email], is_primary: true }
       else
         attributes[:contacts_attributes] << { id: primary_email.id, _destroy: '1' }
        end
      elsif params[:email].present?
        attributes[:contacts_attributes] << { contact_type: :EMAIL, value: params[:email], label: :HOME, is_primary: true }
      end
    end

    # If the phone is present, insert or update the phone on the user contacts
    if params.key?(:phone)
      primary_phone = phones.home.first

      if primary_phone
        if params[:phone].present?
          attributes[:contacts_attributes] << { id: primary_phone.id, value: params[:phone] } if primary_phone.value != params[:phone]
        else
          attributes[:contacts_attributes] << { id: primary_phone.id, _destroy: '1' }
        end
      elsif params[:phone].present?
        attributes[:contacts_attributes] << { contact_type: :PHONE, value: params[:phone], label: :HOME, is_primary: false }
      end
    end

    # If the mobile is present, insert or update the phone on the user contacts
    if params.key?(:mobile)
      primary_mobile = phones.mobile.first

      if primary_mobile
        if params[:mobile].present?
          attributes[:contacts_attributes] << { id: primary_mobile.id, value: params[:mobile] } if primary_mobile.value != params[:mobile]
        else
          attributes[:contacts_attributes] << { id: primary_mobile.id, _destroy: '1' }
        end
      elsif params[:mobile].present?
        attributes[:contacts_attributes] << { contact_type: :PHONE, value: params[:mobile], label: :MOBILE, is_primary: false }
      end
    end

    # Save avatar to guest_details
    if params.key?(:avatar)
      set_avatar_from_base64(params[:avatar])
    end

    # If the address info is present, insert or update the address on the user addresses
    if params.key?(:street) || params.key?(:city) || params.key?(:state) || params.key?(:postal_code) || params.key?(:country)
      primary_address = addresses.primary.first

      if primary_address
        address_attributes = { id: primary_address.id }
        address_attributes[:street1] = params[:street] if params.key?(:street)
        address_attributes[:city] = params[:city] if params.key?(:city)
        address_attributes[:state] = params[:state] if params.key?(:state)
        address_attributes[:postal_code] = params[:postal_code] if params.key?(:postal_code)
        address_attributes[:country_id] = params[:country] if params.key?(:country)

        attributes[:addresses_attributes] << address_attributes
      elsif params[:street].present? || params[:city].present? || params[:state].present? || params[:postal_code].present? || params[:country].present?
        attributes[:addresses_attributes] << { street1: params[:street], city: params[:city], state: params[:state], postal_code: params[:postal_code], country_id: params[:country], label: :HOME, is_primary: true }
      end
    end
    
    # Set the user nested attributes
    self.attributes = attributes
    # DO NOT SAVE USER BEFORE SENDING TO OWS (it needs the user to be *changed* in order to send the appropriate requests)
    if self.valid?
      # If the user is valid and we have an external_id, update guest in OWS
      if external_id
        unless current_hotel.nil?
          guest_api = GuestApi.new(current_hotel.id)
          result = guest_api.update_guest(external_id, self)
        end
      end

      # There is no reason the user should not save at this point
      self.save!

      return { status: SUCCESS, data: { 'message' => 'Success' }, errors: [] }
    else
      return { status: FAILURE, data: {}, errors: errors.full_messages }
    end
  end

  Paperclip.interpolates :guest_prefix do |a, s|
    a.instance.hotel_chain.code
  end

  def get_default_group_avatar
    request = Thread.current[:current_request]
    avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-group.png'
    avatar_url
  end

  # Finds all invalid payment types for this guest, and destroys them
  def destroy_invalid_payment_methods
    payment_methods.invalid.destroy_all
  end

  def future_reservations(business_date, current_reservation)
    reservations.with_status(:RESERVED).where('reservations.id != ? and arrival_date >= ?', current_reservation.id, business_date)
  end

  # Gets a count of future reservations that have an arrival date greater to the business date
  def future_reservation_count(business_date, current_reservation)
    future_reservations(business_date, current_reservation).count
  end
  
   # Add entries to the User Activity Table.
  def record_user_activity( application, hotel_id, action_type, activity_status, message, user_ip_address )
    hotel = Hotel.find(hotel_id)
    activity_date_time = DateTime.strptime(hotel.active_business_date.strftime("%Y %m %d ") + Time.now.utc.in_time_zone(hotel.tz_info).strftime("%H %M %S %:z"),'%Y %m %d %H %M %S %z')
    @activity = user_activities.create( application: application, hotel_id: hotel_id, action_type: action_type,
                                 activity_status: activity_status, message: message, user_ip_address: user_ip_address, activity_date_time: activity_date_time)

    @activity.save!
  end

  private

  # Method to return default avatar
  def get_default_user_avatar
    request = Thread.current[:current_request]
    avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-trans.png'
    if title.present?
      if (title.downcase.include? ('Mr').downcase) && (!title.downcase.include? ('Mrs').downcase)
        avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-male.png'
      elsif (title.downcase.include? ('Mrs').downcase) || (title.downcase.include? ('Ms').downcase)|| (title.downcase.include? ('Miss').downcase)
        avatar_url =   request.protocol + request.host_with_port + '/assets/avatar-female.png' 
      end
      avatar_url
    end
    avatar_url
  end
end
