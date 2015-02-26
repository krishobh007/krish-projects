class Guest::NotificationsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_filter :check_session
  def index
    status, data, errors = FAILURE, [], []
    current_user.notification_details.where('users_notification_details.is_read = false AND users_notification_details.notification_channel =? ', Setting.notification_channel[:push_notification]).order('created_at desc').limit(Setting.defaults[:alert_notification_display_limit]).each do | notification |
      if notification.notification_type != Setting.notification_type[:reservation]
         details = fetch_notification_details(notification)
         data << map_notification(notification, details) if details
      end
    end
    status = SUCCESS
    render json:{ status: status , data: data, errors: errors }
  end

  def show
    status, data, errors = FAILURE, {}, []
      notification = NotificationDetail.find(params[:id])
      details = fetch_notification_details(notification)
      user_notification = UsersNotificationDetail.find_by_user_id_and_notification_detail_id!(current_user.id, params[:id])
      user_notification.is_read = true
      if user_notification.save
       status = SUCCESS
       data = map_notification(notification, details)
      else
        errors = [user_notification.error.full_messages.to_sentence]
      end
    render json:{ status: status , data: data, errors: errors }
  end

  def mark_as_read
    status, data, errors = FAILURE, {}, []
    user_notification = UsersNotificationDetail.find_by_user_id_and_notification_detail_id!(current_user.id, params[:id])
    user_notification.is_read = true
    if user_notification.save
      status, data = SUCCESS, { 'message' => 'message is read' }
    else
       errors = [user_notification.errors.full_messages.to_sentence]
    end
    render json:{ status: status , data: data, errors: errors }
  end

  def device_register

    if !params[:device_UUID].present? && !params[:push_notification_token].present? && !params[:device_type].present?

      response =  { 'status' => FAILURE, 'data' => {}, 'errors' => ['Missing Valid Parameters'] }
      render json: response
    else
      if NotificationDeviceDetail.find_by_unique_id(params[:device_UUID]).present?
        device_detail = NotificationDeviceDetail.find_by_unique_id(params[:device_UUID])
        if device_detail.update_attributes(user_id: current_user.id, registration_id: params[:push_notification_token], device_type: params[:device_type])
          response =  { 'status' => SUCCESS, 'data' => {}, 'errors' => [] }
        else
          response =  { 'status' => FAILURE, 'data' => {}, 'errors' => device_detail.errors.full_messages }
        end
        render json: response
      else
        device_detail = NotificationDeviceDetail.new(user_id: current_user.id,
                                                     unique_id: params[:device_UUID],
                                                     registration_id: params[:push_notification_token],
                                                     device_type: params[:device_type])
      if device_detail.save
        preference = NotificationPreference.find_or_initialize_by_user_id(current_user.id)
        unless preference.id
          preference.save!
        end
        response =  { 'status' => SUCCESS, 'data' => {}, 'errors' => [] }
      else
        response =  { 'status' => FAILURE, 'data' => {}, 'errors' => device_detail.errors.full_messages }
      end
        render json: response

      end
    end
  end

  private

  def fetch_notification_details(notification)
    details = {}
    look_up_model = notification.notification_type.constantize
    details[:content] = look_up_model.find_by_id(notification.notification_id)
    details[:group_id] = (look_up_model == SbPost) ? details[:content].andand.group_id.to_s : ''
    if (look_up_model == Reservation)
      details[:profile_detail] =  details[:content].primary_guest
    elsif (look_up_model == Message)
           details[:profile_detail] =  details[:content].sender.andand.detail
    else
           details[:profile_detail] =   details[:content].user.andand.detail
    end
    details
  end

  def map_notification(notification, details)
    content_id, hotel_id = '', ''
    if details
      if (notification.notification_type ==  Setting.notification_type[:reservation] )
        reservation_id = notification.notification_id
        is_hotel_staff = 'false'
        content_id = notification.notification_id.to_s
        hotel_id = (details[:content] && details[:content].hotel) ? details[:content].hotel.id.to_s : ''
      elsif notification.notification_type == Setting.notification_type[:message]
            message = Message.find(notification.notification_id)
            content_id = message.conversation.id.to_s
            hotel_id = current_user.guest_detail.reservations.first.hotel.id.to_s
            reservation_id = current_user.andand.recent_reservation.andand.id.to_s
            is_hotel_staff = message.sender.hotel_staff?.to_s
      else
        is_hotel_staff = (details[:content].user ? details[:content].user.hotel_staff? : nil).to_s
        content_id = details[:content].attribute_present?(:commentable_id) ? details[:content].commentable_id.to_s : notification.notification_id.to_s
        hotel_id = (details[:content] && details[:content].hotel) ? details[:content].hotel.id.to_s : ''
        reservation_id = current_user.andand.recent_reservation.andand.id.to_s
      end
      data = {
        'notification_id' => notification.id.to_s,
        'notification_section_id' => Setting.notification_section_id[notification.notification_section].to_s,
        'notification_section' => notification.notification_section,
        'hotel_id' => hotel_id.to_s,
        'content_id' => content_id.to_s ,
        'content_sub_id' => details[:content].attribute_present?(:commentable_id) ? notification.notification_id.to_s : '',
        'profile_image_url' =>  details[:profile_detail].andand.avatar.andand.url(:thumb).to_s,
        'created_time' => time_ago_in_words(details[:content].updated_at),
        'alert_message' => notification.message,
        'is_hotel_staff' => is_hotel_staff.to_s,
        'reservation_id' => reservation_id.to_s,
        'group_id' => details[:group_id].to_s
      }
    else
      data = {}
    end
    data
  end
end
