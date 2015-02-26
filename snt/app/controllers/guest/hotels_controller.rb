class Guest::HotelsController < ApplicationController
  before_filter :check_session

  def late_checkout_settings
    data = {}
    errors = []
    status = FAILURE
    is_offer_available = 'false'
    hotel = Hotel.find(params[:hotel_id])
    data['hotel_id'] = hotel.id.to_s
    data['currency'] = hotel.default_currency.andand.symbol.to_s
    if hotel.late_checkout_available?
      is_offer_available = 'true'
      late_checkout_offers = hotel.late_checkout_offers
    end
    status = SUCCESS
    data['is_offer_available'] = is_offer_available
    data['late_checkout_offers'] = late_checkout_offers

    render json: { status: status, data: data, errors: errors }
 end

  # METHOD TO GET HOTEL REVIEW CATEGORIES
  def hotel_review_categories
    status, errors, data = FAILURE, [], {}
    hotel = Hotel.find(params[:hotel_id])
    data = hotel.review_categories.map do|category|
      ViewMappings::GuestZest::ReviewsMapping.map_hotel_review_categories(category)
    end
    status = SUCCESS
    render json: { status: status, data: data, errors: errors }
  end

  def get_message_count
    status, errors, data, count = FAILURE, [], {}, 0
    hotel = Hotel.find(params[:hotel_id])
    if params[:section_name].present?
      if params[:section_name] == Setting.message_section[:sl_posts]
        count = hotel.posts.where('sb_posts.id > ? AND group_id IS NULL ', params[:section_id]).count.to_s

      elsif params[:section_name] == Setting.message_section[:reviews]
        count = hotel.reservations.joins(:reviews).where('reviews.id > ?', params[:section_id]).count.to_s

      elsif params[:section_name] == Setting.message_section[:my_group]
        starting_post = hotel.posts.find(params[:section_id])
        count = hotel.posts.where('sb_posts.id > ? AND sb_posts.group_id=?', params[:section_id], starting_post.group.id).count.to_s

      elsif (params[:section_name] == Setting.message_section[:text_to_staff])
       count = MessagesRecipients.where("message_id > ? AND recipient_id=?",params[:section_id],current_user.id).count
      end

      data['section_name'] = params[:section_name]
      data['message_count'] = count.to_s
      status = SUCCESS
    end
    render json: { status: status, data: data, errors: errors }
  end

  def staff_directory
    data, errors, status = [], [], FAILURE
    current_hotel = Hotel.find(params[:hotel_id])
    data = current_hotel.users.with_staff_role.collect{|staff|
      ViewMappings::GuestZest::DashboardMapping.map_staff_directory(staff)
      }
    #data = JSON.parse(File.read("#{Rails.root}/public/sample_json/guest_zest/staff_directory.json"))
    status = SUCCESS
    render json: { status: status, data: data, errors: errors }
  end
end
