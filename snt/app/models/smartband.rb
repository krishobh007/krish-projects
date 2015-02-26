class Smartband < ActiveRecord::Base
  attr_accessible :reservation_id, :first_name, :last_name, :account_number, :is_fixed, :amount, :name_required
  attr_accessor :name_required

  belongs_to :reservation

  validates :reservation, :account_number, presence: true
  validates :first_name, :last_name, presence: true, if: :name_required

  validates :amount, presence: true, if: :is_fixed
  validates :amount, numericality: true, allow_nil: true
  validate :account_number_unique
  validate :on_active_reservation

  def account_number_unique
    smartbands = Smartband.includes(:reservation).where('reservations.hotel_id = ? and account_number = ?',
                                                        reservation.andand.hotel_id, account_number)
    smartbands = smartbands.where('smartbands.id != ?', id) if persisted?

    errors.add(:account_number, :uniqueness) if smartbands.exists?
  end

  def on_active_reservation
    errors.add(:reservation, :checked_out) if reservation.status === :CHECKEDOUT
  end

  scope :fixed, -> { where(is_fixed: true) }
  scope :has_balance, -> { fixed.where('amount > 0') }

  # Get an updated amount from icare and save
  def sync_amount_with_icare
    result = IcareApi.new(reservation).balance_inquiry(account_number)

    if result[:status]
      self.amount = result[:data][:amount]
      save
    end

    result
  end

  # Issue and activate the account with icare
  def issue_account_with_icare
    icare = IcareApi.new(reservation)
    result = icare.issue(account_number, amount)
    save_customer_settings = reservation.hotel.settings.icare_save_customer_info
    save_customer_info = save_customer_settings.nil? ? Setting.defaults[:icare_save_customer_info] : save_customer_settings
    # Create a customer for Icare and link with given account number
    # Only if first name & last are present CICO-9174
    if result[:status] && save_customer_info && first_name.present? && last_name.present?
      result = icare.create_customer(first_name, last_name, account_number)
    end
    result
  end

  # Reload a credit amount with icare
  def reload_account_with_icare(credit)
    IcareApi.new(reservation).reload(account_number, credit)
  end

  # Cash out the account with icare
  def cash_out_with_icare
    result = IcareApi.new(reservation).cash_out(account_number)

    if result[:status]
      self.amount = 0
      save
    end

    result
  end

  # Sync all of the fixed smartbands with icare
  def self.sync_smartbands_with_icare(smartbands)
    result = { status: true, errors: [] }

    smartbands.each do |smartband|
      if result[:status] && smartband.is_fixed
        result = smartband.sync_amount_with_icare
      end
    end

    result
  end

  # Post a charge to the external PMS if configured
  def post_charge_to_external_pms(amount, is_debit, description)
    hotel = reservation.hotel

    if hotel.is_third_party_pms_configured?
      charge_code_id = is_debit ? hotel.settings.icare_debit_charge_code_id : hotel.settings.icare_credit_charge_code_id
      charge_code = hotel.charge_codes.find_by_id(charge_code_id)

      pms_api = PostChargesApi.new(hotel.id)

      charge_details = {
        posting_date: hotel.active_business_date,
        posting_time: Time.now,
        long_info: description,
        charge: amount,
        bill_no: 1
      }

      pms_api.update_post_charges(charge_code.charge_code, reservation.external_id, charge_details)[:status]
    end
  end

  #
  def send_alert_to_external_pms(action_type)
    hotel = reservation.hotel
    band_type = :is_fixed ? 'Stored' : 'Room Charge'
    alert_desc = "ID = #{account_number}, Name = #{first_name} #{last_name}, Type = #{band_type}"
    alert_code = hotel.settings.pms_alert_code
    alert_area = 'Check-Out'

    if hotel.is_third_party_pms_configured?
      alert_api = ReservationApi.new(hotel.id)
      alert_api.guest_alert_requests(reservation.confirm_no, action_type, alert_area, alert_code, alert_desc)
    end
  end

  def send_smartband_key_data_to_external_pms
    hotel = reservation.hotel
    set_key_data_api = ReservationApi.new(hotel.id)
    set_key_data_api.send_smartband_key_data(account_number, reservation.external_id)
  end
end
