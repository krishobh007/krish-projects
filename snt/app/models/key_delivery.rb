# View Model for the key delivery admin page
class KeyDelivery
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :hotel, :room_key_delivery_for_guestzest_check_in, :room_key_delivery_for_rover_check_in,
                :key_system_id, :key_access_url, :key_access_port, :key_username, :key_password, :key_delivery_message

  validates :key_system_id, :key_access_url, presence: true, if: :encode_selected?

  def encode_selected?
    room_key_delivery_for_rover_check_in == 'encode'
  end

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      hotel.settings.room_key_delivery_for_guestzest_check_in = room_key_delivery_for_guestzest_check_in
      hotel.settings.room_key_delivery_for_rover_check_in = room_key_delivery_for_rover_check_in
      hotel.settings.key_delivery_message = key_delivery_message
      if self.encode_selected?
        hotel.update_attributes(key_system_id: key_system_id)

        hotel.settings.key_access_url = key_access_url
        hotel.settings.key_access_port = key_access_port
        hotel.settings.key_username = key_username
        hotel.settings.key_password = key_password
        hotel.settings.key_delivery_message = key_delivery_message
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
