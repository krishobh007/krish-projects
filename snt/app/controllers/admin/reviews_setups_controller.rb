class Admin::ReviewsSetupsController < ApplicationController
  before_filter :check_session

  def index
    data = ViewMappings::ReviewsSetupsMapping.map_reviews_setup(current_hotel)

    respond_to do |format|
      format.html { render partial: 'guest_reviews', locals: { data: data,  errors: [] } }
      format.json { render json: { status: SUCCESS,  data: data, errors: [] } }
    end
  end

  def update
    status = SUCCESS
    errors = []

    setup = AdminReviewsSetup.new(ViewMappings::ReviewsSetupsMapping.map_reviews_setup_post_params(params))
    setup.hotel = current_hotel

    unless setup.save
      status = FAILURE
      errors = setup.errors.full_messages
    end

    render json: { status: status,  data: {}, errors: errors }
  end
end
