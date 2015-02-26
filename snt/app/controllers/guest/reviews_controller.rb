class Guest::ReviewsController < ApplicationController
  before_filter :check_session

  # METHOD TO LIST ALL REVIEWS OF A HOTEL
  def review_list
    data = []
    errors = []
    status = FAILURE
    hotel = Hotel.find(params[:hotel_id])
    if hotel.review_list.present?
      data =  hotel.review_list.joins(:user).map { |review| ViewMappings::GuestZest::ReviewsMapping.map_review_details(review) }
    end
    status = SUCCESS
    render json: { status: status, data: data, errors: errors }
  end

  # METHOD TO RETURN GUEST REVIEW DETAILS OF A RESERVATION
  def review_details
    data, errors , details, status = {}, [], [], FAILURE
    if params[:review_id]
      review = Review.find(params[:review_id])
      reservation = review.reservation
      data =  ViewMappings::GuestZest::ReviewsMapping.map_review_details(review)
      hotel = reservation.hotel
      review_details = []
      management_responses = []
      hotel_review_categories = hotel.review_categories.each do |hotel_category|
        user_rating =  review.review_ratings.where(review_category_id: hotel_category.id).first
        review_details << {
          'category_name' => hotel_category.value,
          'rating' => user_rating ? user_rating.rating : ''
        }
      end

      if review.comments.present?
        management_responses = review.comments.map do|management_response|
          ViewMappings::GuestZest::ReviewsMapping.map_management_responses(management_response)
        end
      end

      data['review_details'] = review_details
      data['management_responses'] = management_responses
      status = SUCCESS
    else
      errors << I18n.t(:invalid_parameters)
    end
    render json: { status: status, data: data, errors: errors }
  end

  # Create Reviews for a Hotel
  def review_hotel
    data, errors, details, status = {}, [], [], FAILURE
    pms_session = PmsSession.find_by_session_id(params[:access_token])
    current_user = pms_session.user
    if params[:reservation_id] && params[:review_title] && params[:review_description]
      reservation = Reservation.find(params[:reservation_id])
      begin
        review = Review.create!(reservation_id: reservation.id, title: params[:review_title], description: params[:review_description], creator_id: current_user.id, updater_id: current_user.id)
        # review.creator_id=current_user.id
       # review.updater_id=current_user.id
        # review.save
        if params[:review_details]
          params[:review_details].each do |rating|
            review.review_ratings.create!(rating: rating[:rating], review_category_id: rating[:review_category_id])
          end
        end
        status = SUCCESS
        data['message'] =  I18n.t(:thank_you)
      rescue ActiveRecord::RecordInvalid => ex
        errors = [ex.message]
      end
    else
      errors << I18n.t(:invalid_parameters)
    end
    render json: { status: status, data: data, errors: errors }
     end
end
