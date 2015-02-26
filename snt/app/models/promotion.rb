class Promotion < ActiveRecord::Base
  attr_accessible :title, :description, :image_id, :is_inactive, :hotel_id
  
  has_many :beacons
  
  has_one :picture, class_name: 'Image', as: :image_attachable
  
  
  def picture_from_base64(base64_data)
    base64_data = base64_data.split('base64,')[1]
    file_name = "picture#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(ActiveSupport::Base64.decode64(base64_data))
    end
    picture_file = File.open(image_path)
    self.picture = Image.new
    self.picture.image = picture_file
    self.picture.save!
    File.delete(image_path)
  end
  
end