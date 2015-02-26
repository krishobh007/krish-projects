module SeedUsers
  def create_users
    admin_user = User.find_by_login('admin@stayntouch.com')
    yotel_chain = HotelChain.find_by_code('YOT')
    api_user = User.find_by_email('apiuser@yotel.com')

    unless admin_user
      admin_user = User.new(email: 'admin@stayntouch.com', login: 'admin@stayntouch.com', password: 'R}v5 x{6FG', password_confirmation: 'R}v5 x{6FG')
      admin_user.build_staff_detail(first_name: 'SNT Admin', last_name: 'SNT Admin')

      admin_user.roles = [Role.admin]
      admin_user.activated_at = Time.now.utc
      admin_user.activation_code = nil
      admin_user.save
    end

    unless api_user
      if yotel_chain.present?
        api_user = User.new(email: 'apiuser@yotel.com', login: 'test', password: '2r6=c_p6X', password_confirmation: '2r6=c_p6X', hotel_chain_id:  yotel_chain.id)
        api_user.roles = [Role.api_user]
        api_user.activated_at = Time.now.utc
        api_user.activation_code = nil
        api_user.save!
      end
    end
  end
end
