module SeedTestUsers
  def create_test_users
    hotel_chain_id = HotelChain.find_by_code('CHA').id
    guest_user = User.find_by_login('guestone@hotel.com')
    vip_user = User.find_by_login('vip@hotel.com')
    yotel_chain = HotelChain.find_by_code('YTL')
    api_user = User.find_by_email('apiuser@yotel.com')

    unless guest_user
      guest_user = User.create(email: 'guestone@hotel.com', login: 'guestone@hotel.com', password: 'guest123', password_confirmation: 'guest123', hotel_chain_id: hotel_chain_id)

      guest_user.roles = [Role.guest]
      guest_user.activated_at = Time.now.utc
      guest_user.activation_code = nil
      guest_user.save

      guest_user_details = GuestDetail.create(is_vip: false, title: 'Mr.', first_name: 'Guest', last_name: 'Guest', hotel_chain_id: hotel_chain_id)
      guest_user_details.user_id = guest_user.id
      guest_user_details.contacts.build(contact_type: :EMAIL, value: guest_user.email, label: :HOME, is_primary: true)
      guest_user_details.save
    end

    unless vip_user
      vip_user = User.create(email: 'vip@hotel.com', login: 'vip@hotel.com', password: 'vip123', password_confirmation: 'vip123', hotel_chain_id: hotel_chain_id)

      vip_user.roles = [Role.guest]
      vip_user.activated_at = Time.now.utc
      vip_user.activation_code = nil
      vip_user.save

      vip_user_details = GuestDetail.create(is_vip: true, title: 'Mr.', first_name: 'VIP', last_name: 'VIP', hotel_chain_id: hotel_chain_id)
      vip_user_details.user_id = vip_user.id
      vip_user_details.contacts.build(contact_type: :EMAIL, value: vip_user.email, label: :HOME, is_primary: true)
      vip_user_details.save
    end

    unless api_user
      if yotel_chain.present?
        api_user = User.new(email: 'apiuser@yotel.com', login: 'test', password: 'test123', password_confirmation: 'test123', hotel_chain_id:  yotel_chain.id)
        api_user.roles = [Role.api_user]
        api_user.activated_at = Time.now.utc
        api_user.activation_code = nil
        api_user.save!
      end
    end
  end
end
