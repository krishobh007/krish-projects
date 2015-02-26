class ViewMappings::GuestZest::DashboardMapping
  
  def self.map_reservation_details(reservation, hotel = nil)
    reservation_details = {}
    hotel = hotel || reservation.hotel
    cms_components = hotel.cms_components.published
    if reservation.present?
      current_daily_instance = reservation.current_daily_instance
      if current_daily_instance
        current_room_instance = Room.where(hotel_id: reservation.hotel_id, room_no: current_daily_instance.room ? current_daily_instance.room.andand.room_no : '').first
      end
      arr_grace = reservation.hotel.arr_grace_period ? reservation.hotel.arr_grace_period : 0
      dep_grace = reservation.hotel.dep_grace_period ? reservation.hotel.dep_grace_period : 0

      user = reservation.primary_guest.user

      is_social_lobby_first_time = (user && user.sb_last_seen_at) ? false : true

      # To Findout profile user by matching reservations with guest_details where user_id is not null
      profile_user = reservation.guest_details.where('user_id is not null').first
     
      reservation_details = {
        id: reservation.id.to_s,
        user_id: user ? user.id.to_s : '',
        hotel_id: reservation.hotel_id.to_s,
        last_name: reservation.primary_guest.last_name.to_s,
        first_name: reservation.primary_guest.first_name.to_s,
        arrival_date: reservation.arrival_date.to_s,
        dep_date: reservation.dep_date.to_s,
        hotel_phone: reservation.hotel.hotel_phone.to_s,
        confirm_no: reservation.confirm_no.to_s,
        room_no: current_daily_instance.andand.room.andand.room_no.to_s,
        status:  ViewMappings::StayCardMapping.map_view_status(reservation, reservation.hotel.active_business_date).to_s,
        hotel_name: reservation.hotel.name.to_s,
        is_review_present: reservation.hotel.settings.is_guest_reviews_on.to_s,
        has_primary_card: reservation.is_cc_attached?.to_s,
        is_late_checkouts_available: reservation.is_late_checkout_available?.to_s,
        is_profile_completed: profile_user ? profile_user.get_profile_completed_status : 'false',
        is_firsttime_checkin: ViewMappings::StayCardMapping.get_first_time_checkin_status(reservation, reservation.hotel.active_business_date),
        force_upsell: hotel.settings.upsell_is_force.to_s,
        upsell_available: reservation.current_daily_instance.andand.room_type.andand.upsell_available?(reservation).to_s,
        room_type_name: reservation.current_daily_instance.andand.room_type.andand.room_type_name ? reservation.current_daily_instance.room_type.room_type_name : '',
        group_code: current_daily_instance.andand.group.andand.group_code.to_s,
        group_id: current_daily_instance.andand.group_id.to_s,
        lobby_status: reservation.lobby_status.to_s,
        hotel_business_date: reservation.hotel.active_business_date,
        checkin_date_with_grace: (reservation.arrival_date - arr_grace.days).to_s,
        checkout_date_with_grace: (reservation.dep_date + dep_grace.days).to_s,
        sociallobby_first_time: is_social_lobby_first_time.to_s,
        room_type: current_daily_instance.andand.room_type.andand.room_type.to_s,
        room_status: current_room_instance.andand.is_ready? ? 'READY' : 'NOTREADY', # reservation.room_status,
        fo_status:  current_room_instance.andand.is_occupied ? 'OCCUPIED' : 'VACANT'.to_s,
        wake_up_call_time: (reservation.get_wakeup_time ? reservation.get_wakeup_time['wake_up_time'] : '').to_s,
        note_topics: [],
        note_topic_items: reservation.notes ? reservation.notes.map { |note| { 'id' => note.note_type.id.to_s, 'value' => note.note_type.value } }.uniq : [],
        news_paper_pref: reservation.hotel.get_newspaper_features(reservation),
        newspaper: reservation.features.newspaper.first.andand.value, # #TODO Remove After Mobile team completes the news_paper_pref implementaion
        newspaper_options: hotel.features.newspaper.map { |feature| feature.value }, # #TODO Remove After Mobile team completes the news_paper_pref implementaion
        is_upsell_selected: reservation.is_upsell_applied.to_s,
        arrival_time: reservation.arrival_time.andand.strftime("%I:%M %p").to_s,
        departure_time: reservation.departure_time.andand.strftime("%I:%M %p").to_s,
        rate_name: reservation.current_daily_instance.andand.rate.andand.rate_name ? reservation.current_daily_instance.andand.rate.andand.rate_name.to_s : '',
        rate_amount: reservation.is_rate_suppressed || !reservation.current_daily_instance.andand.rate_amount ? '0.00' : reservation.current_daily_instance.formatted_currency.to_s,
        currency_symbol: reservation.current_daily_instance.andand.currency_code ? reservation.current_daily_instance.andand.currency_code.andand.symbol.to_s : '',
      }
    end
    reservation_details.merge!({
      hotel_id: hotel.id.to_s,
      hotel_name: hotel.name.to_s,
      section_info: cms_components.sections.select{ |section| section.has_valid_branches? }.map do |section|
          {
            component_name: section.name.to_s,
            component_id: section.id.to_s,
            component_type: section.component_type.to_s,
            icon_url: section.icon.andand.image.andand.url(:thumb).to_s,
            icon_name: section.icon.andand.image.andand.name.to_s,
            website_url: section.website_url.to_s,
            last_updated: section.updated_at.to_i.to_s
          }

        end
      })
    reservation_details
  end

  def self.map_all_reservations(reservations)
    results = reservations.map do |reservation|
      map_reservation_summary(reservation)
    end
    results
  end

  def self.map_reservation_summary(reservation)
    reservation = {
      id: reservation.id.to_s,
      hotel_name: reservation.hotel.name.to_s,
      arrival_date: reservation.arrival_date.to_s,
      dep_date: reservation.dep_date.to_s,
      status: ViewMappings::StayCardMapping.map_view_status(reservation, reservation.hotel.active_business_date).to_s,
      confirm_no: reservation.confirm_no.to_s,
      hotel_business_date: reservation.hotel.active_business_date.to_s
    }
    reservation
  end

  def self.map_staff_directory(staff)
    {
      staff_id: staff.id.to_s,
      full_name: staff.andand.staff_detail.andand.full_name.to_s,
      job_title: staff.andand.staff_detail.andand.job_title.to_s,
      avatar:  staff.andand.staff_detail.andand.avatar.url(:thumb).to_s
    }
  end

  def self.map_conversation_list(message, current_user,is_detail_view=false)
    is_group_conversation = message.andand.conversation.andand.is_group_conversation
    avatar_image = (is_group_conversation && !is_detail_view) ? message.andand.sender.andand.detail.get_default_group_avatar.to_s : message.andand.sender.andand.detail.andand.avatar.andand.url(:thumb).to_s
    {
      conversation_id: message.conversation.id.to_s,
      message_id: message.id.to_s,
      full_name: message.andand.sender.andand.full_name.to_s,
      job_title:  message.andand.sender.andand.detail.andand.job_title.to_s,
      message: message.message.to_s,
      avatar:  avatar_image,
      is_read: message.messages_recipients.where('recipient_id=?', current_user.id).first.andand.is_read.to_s,
      is_guest: message.andand.sender.andand.guest?.to_s,
      is_group_conversation: message.andand.conversation.andand.is_group_conversation.to_s,
      created_at: ViewMappings::GuestZest::ReviewsMapping.map_created_at_time(message.created_at).to_s
    }
  end
end
