class StaffDetail < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :id, :job_title, :user_id, :avatar_content_type, :avatar_file_name, :avatar_file_size

  attr_accessible :avatar

  belongs_to :user

  validates :last_name, :first_name, presence: true
  validates :user_id, uniqueness: true

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':staff_prefix/Users/:class/:id/:attachment/:style/:filename', default_url: :get_default_user_avatar

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

  def full_name
    [self.first_name, self.last_name].compact.join(' ')
  end

   def get_default_group_avatar
    request = Thread.current[:current_request]
    avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-group.png'
    avatar_url
   end


  Paperclip.interpolates :staff_prefix do |a, s|
    a.instance.user.default_hotel.hotel_chain.code
  end
  # Method to return default avatar
  private
  def get_default_user_avatar
    request = Thread.current[:current_request]
    avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-trans.png'
    if title.present?
      if (title.downcase.include? ('Mr').downcase) && (!title.downcase.include? ('Mrs').downcase)
        avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-male.png'
      elsif (title.downcase.include? ('Mrs').downcase) || (title.downcase.include? ('Ms').downcase)
        avatar_url =   request.protocol + request.host_with_port + '/assets/avatar-female.png'
      end
      avatar_url
    end
    avatar_url
   end
end
