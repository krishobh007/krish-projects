class Guest::NotificationPreferencesController < ApplicationController
  before_filter :check_session

  def show
    status, data, errors = FAILURE, {}, []
    preference = NotificationPreference.find_or_initialize_by_user_id(current_user.id)
    status = SUCCESS
    render json: { status: status , data: preference, errors: errors }
  end

  def save
    status, data, errors = FAILURE, {}, []
    preference = NotificationPreference.find_or_initialize_by_user_id(current_user.id)
    if preference.update_attributes(params[:notification_preference])
      status = SUCCESS
    else
      errors<< preference.errors.full_messages.to_sentence
    end
    render json: { status: status , data: preference, errors: errors }
  end
end
