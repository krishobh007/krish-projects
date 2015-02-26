# View Model for the hotel settings
class HotelSetting
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :hotel, :checkin_inspected_only, :use_pickup, :use_inspected, :icare_enabled, :icare_debit_charge_code_id,
                :icare_credit_charge_code_id, :icare_username, :icare_password, :icare_url,
                :icare_account_preamble, :icare_account_length, :is_queue_rooms_on, :pms_alert_code,
                :is_auto_change_bussiness_date, :business_date_change_time, :icare_save_customer_info,
                :enable_room_status_at_checkout, :is_auto_assign_ar_numbers, :icare_combined_key_room_charge_create,
                :no_show_charge_code_id


  validates :icare_debit_charge_code_id, :icare_credit_charge_code_id, :icare_username, :icare_password, :icare_url,
            :icare_account_length, presence: true, if: :icare_enabled
  validates :icare_debit_charge_code_id, :icare_credit_charge_code_id, :icare_account_length, numericality: { only_integer: true }, allow_nil: true

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      [:checkin_inspected_only, :use_pickup, :use_inspected, :icare_enabled, :icare_debit_charge_code_id, :icare_credit_charge_code_id,
       :icare_username, :icare_password, :icare_url, :icare_account_preamble, :icare_account_length, :is_queue_rooms_on, :pms_alert_code,
       :is_auto_change_bussiness_date, :business_date_change_time,
       :is_auto_assign_ar_numbers, :icare_save_customer_info,
       :enable_room_status_at_checkout, :icare_combined_key_room_charge_create, :no_show_charge_code_id]
        .each { |attribute| apply_settings_if_present(attribute) }

      true
    else
      false
    end
  end

  def attributes=(attributes)
    attributes = (attributes || {}).symbolize_keys
    attributes.keys.each do |k|
      if self.class.instance_methods.include?(:"#{k}=")
        send(:"#{k}=", attributes[k])
      end
    end
  end

  def [](attribute)
    send attribute
  end

  private

  def apply_settings_if_present(attribute)
    hotel.settings[attribute] = self[attribute] unless self[attribute].nil?
  end
end
