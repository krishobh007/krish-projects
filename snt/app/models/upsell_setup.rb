# View Model for the upsell admin page
class UpsellSetup
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :hotel, :upsell_is_on, :upsell_is_one_night_only, :upsell_is_force, :upsell_total_target_amount, :upsell_total_target_rooms,
                :upsell_charge_code_id, :upsell_amounts, :upsell_room_levels

  validates :upsell_total_target_amount, :upsell_total_target_rooms, :upsell_charge_code_id, presence: true, if: :upsell_is_on
  validates :upsell_total_target_amount, :upsell_total_target_rooms, numericality: true, allow_blank: true
  validates :upsell_total_target_rooms, numericality: { only_integer: true }, allow_blank: true
  validate :upsell_amounts_valid?

  def upsell_amounts_valid?
    if upsell_is_on
      valid = true

      upsell_amounts.andand.each do |upsell_amount|
        valid &&= upsell_amount.valid?
      end

      errors.add(:upsell_amounts, 'are invalid') unless valid
    end
  end

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      hotel.settings.upsell_is_on = upsell_is_on
      hotel.settings.upsell_is_one_night_only = upsell_is_one_night_only
      hotel.settings.upsell_is_force = upsell_is_force
      hotel.settings.upsell_total_target_amount = upsell_total_target_amount
      hotel.settings.upsell_total_target_rooms = upsell_total_target_rooms

      # Update the hotel upsell charge code
      hotel.update_attributes!(upsell_charge_code_id: upsell_charge_code_id)

      # Recreate the hotel upsell amounts
      hotel.upsell_amounts.where('id not in (?)', upsell_amounts.map(&:id)).destroy_all
      upsell_amounts.each do |upsell_amount|
        upsell_amount.save
      end

      # Recreate the hotel upsell room levels
      hotel.room_types.each do |room_type|
        room_type.upsell_room_level.andand.destroy
      end
      upsell_room_levels.andand.each do |upsell_level|
        upsell_level[:room_types].andand.each do |room_type|
          UpsellRoomLevel.create!(room_type_id: room_type[:room_type_id], level: upsell_level[:level_id])
        end
      end

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
