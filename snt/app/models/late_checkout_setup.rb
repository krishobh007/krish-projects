# View Model for the late checkout admin page
class LateCheckoutSetup
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :hotel, :late_checkout_is_on, :late_checkout_is_pre_assigned_rooms_excluded, :late_checkout_num_allowed,
                :late_checkout_upsell_alert_time, :late_checkout_charge_code_id, :late_checkout_charges

  validates :late_checkout_charge_code_id, :late_checkout_num_allowed, :late_checkout_charges, presence: true, if: :late_checkout_is_on
  validates :late_checkout_num_allowed, numericality: { only_integer: true }, allow_blank: true
  validate :late_checkout_charges_valid?

  def late_checkout_charges_valid?
    if late_checkout_is_on
      valid = true

      late_checkout_charges.andand.each do |charge|
        valid &&= charge.valid?
      end

      errors.add(:late_checkout_charges, 'are invalid') unless valid
    end
  end

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      hotel.settings.late_checkout_is_on = late_checkout_is_on
      hotel.settings.late_checkout_is_pre_assigned_rooms_excluded = late_checkout_is_pre_assigned_rooms_excluded
      hotel.settings.late_checkout_num_allowed = late_checkout_num_allowed
      hotel.settings.late_checkout_upsell_alert_time = late_checkout_upsell_alert_time

      # Update the hotel late checkout charge code
      hotel.update_attributes!(late_checkout_charge_code_id: late_checkout_charge_code_id)

      # Recreate the hotel late checkout charges
      hotel.late_checkout_charges.destroy_all
      hotel.late_checkout_charges << late_checkout_charges

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
end
