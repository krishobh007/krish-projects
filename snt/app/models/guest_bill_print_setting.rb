class GuestBillPrintSetting < ActiveRecord::Base
  attr_accessible :logo_type, :show_hotel_address, :custom_text_header, :custom_text_footer, :hotel_id

  #Associations
  belongs_to :hotel
  has_one :location_image, class_name: 'Image', as: :image_attachable

  def set_location_image(raw_post_image)
    base64_data = raw_post_image.split('base64,')[1]
    file_name = "image#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(ActiveSupport::Base64.decode64(base64_data))
    end
    logo_file = File.open(image_path)
    self.location_image = Image.new
    self.location_image.image = logo_file
    self.location_image.save!
    self.save!
    File.delete(image_path)
  end
end

