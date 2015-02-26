class Bill < ActiveRecord::Base
  attr_accessible :bill_number, :reservation_id, :account_id, :created_at

  has_many :financial_transactions, dependent: :destroy
  belongs_to :reservation
  belongs_to :account
  has_many :charge_routings, dependent: :destroy
  has_many :incoming_charge_routings, class_name: 'ChargeRouting', foreign_key: :to_bill_id, dependent: :destroy
  has_many :ar_transactions
  
  validates :bill_number, :reservation_id, presence: true
  validates :reservation_id, uniqueness: { scope: :bill_number }

  scope :one, -> { where(bill_number: 1) }

  def self.create_or_update_bills(invoice_data, reservation)
    invoice_data.each do |bill|
      # Bill Id will be searched by bill number and reservation_id combination
      @bill = Bill.find_or_initialize_by_bill_number_and_reservation_id(bill[:bill_no], reservation.id)

      @bill.save
      FinancialTransaction.create_or_update_transaction(bill[:bill_items], @bill, reservation.hotel) if @bill
    end
  end

  def current_balance
    financial_records = financial_transactions.where('financial_transactions.charge_code_id IS NOT NULL')
    total_debit_amount = financial_records.is_active.exclude_payment.sum(:amount)
    total_credit_amount = financial_records.is_active.credit.sum(:amount)
    
    bill_balance = total_debit_amount.andand.round(2) - total_credit_amount.andand.round(2)
    bill_balance
  end
  
  def bill_data_for_email(reservation)
    data = reservation.guest_bill_details(self)
    data[:payment_details] = reservation.payment_methods.where(bill_number: bill_number).map do |payment|
      {
        description: payment.payment_type.description,
        card_number: payment.mli_token_display
      }
    end
    hotel = reservation.hotel
    print_setting = hotel.guest_bill_print_setting

    hotel_logo = ''
    if print_setting.andand.logo_type == 'ROVER'
      hotel_logo = hotel.icon(:thumb).to_s
    elsif print_setting.andand.logo_type == 'TEMPLATE'
      hotel_logo = hotel.andand.template_logo(:thumb).to_s
    end
    local_image = "#{Rails.root}/public/#{File.basename hotel_logo}"
    unless File.exists? local_image
      File.open(local_image, 'wb') do |f| 
        f.write HTTParty.get(hotel_logo).parsed_response
      end       
    end

    if reservation.primary_guest.andand.contact_info.present?
      data[:guest_details] = reservation.primary_guest.contact_info
      data[:guest_details][:country] = Country.find(reservation.primary_guest.contact_info[:country]).andand.name if reservation.primary_guest.contact_info[:country]
    end
    data[:confirmation_number] = reservation.confirm_no
    data[:arrival_date] =  reservation.arrival_date.strftime(reservation.hotel.date_format) if reservation.arrival_date.present?
    data[:departure_date] = reservation.dep_date.strftime(reservation.hotel.date_format) if reservation.dep_date.present?
    data[:invoice_number] = bill_number
    data[:invoice_date] = hotel.active_business_date.strftime('%d/%m/%Y')
    data[:room_number] = reservation.current_daily_instance.andand.room.andand.room_no
    data[:hotel_name] = hotel.name.to_s
    data[:hotel_address] =  [hotel.name, hotel.city, hotel.state, hotel.country.name].join(',')
    data[:city] = hotel.city.to_s
    data[:state] = hotel.state.to_s
    data[:country] = hotel.country.name.to_s
    data[:zipcode] = hotel.zipcode.to_s
    data[:street] = hotel.street.to_s
    data[:hotel_logo] = hotel_logo
    data[:hotel_logo_for_pdf] = local_image
    data[:custom_text_header] = print_setting.andand.custom_text_header
    data[:custom_text_footer] = print_setting.andand.custom_text_footer
    data[:show_hotel_address] = print_setting.andand.show_hotel_address

    data
  end
 
end
