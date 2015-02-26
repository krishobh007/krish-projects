class Guest::ConversationsController < ApplicationController
  before_filter :check_session

  respond_to :json

  def list
    # current_user = User.find(4)
    data, errors, status = [], [], FAILURE
    recent_converstations = current_user.conversations.sort { |x, y| y.messages.last[:updated_at] <=> x.messages.last[:updated_at] }
    filtered_conversations = Kaminari.paginate_array(recent_converstations).page(params[:page]).per(params[:limit])
    data = filtered_conversations.map{ |conversation|
      ViewMappings::GuestZest::DashboardMapping.map_conversation_list(conversation.messages.last, current_user, false)
    }
    # data = JSON.parse(File.read("#{Rails.root}/public/sample_json/guest_zest/conversations_list.json"))
    status = SUCCESS
    render json: { status: status, data: data, errors: errors }
  end

  def details
    # current_user = User.find(4)
    data, errors, status = [], [], FAILURE
    conversation = Conversation.find(params[:conversation_id])
    conversation.messages.sort { |x, y| y[:created_at] <=> x[:created_at] }.group_by { |message| message[:created_at].strftime('%m/%d/%y') }.each do |key, messages|
      data << messages.sort { |x, y| y[:created_at] <=> x[:created_at] }.map { |message|
        ViewMappings::GuestZest::DashboardMapping.map_conversation_list(message, current_user, true)
      }
    end
    current_user.messages_recipients.where('message_id IN (?)', conversation.messages.pluck(:id)).each do |user_msg|
      user_msg.update_attributes(is_read: true)
    end
    # data = JSON.parse(File.read("#{Rails.root}/public/sample_json/guest_zest/conversations_details.json"))
    status = SUCCESS
    render json: { status: status, data: data, errors: errors }
  end

  def create
    # current_user = User.find(1)
    data, errors, status = {}, [], FAILURE
    if params[:conversation_id].present?
      conversation = Conversation.find(params[:conversation_id])
      recipients = conversation.messages.last.recipients
    else
      recipients = User.where('id IN (?)', params[:recipient_ids])
      conversation = current_user.conversations.create(is_group_conversation: (recipients.count > 1))
    end

    if conversation && !conversation.errors.present?
      message = conversation.messages.create(message: params[:message], sender_id: current_user.id)
      unless message.errors.present?
        recipients << current_user unless recipients.include?(current_user)
        message.recipients  << recipients if recipients.present?
        message.messages_recipients.find_by_recipient_id(current_user.id).update_attributes(is_read: true) if message.recipients
        data[:message] = 'success'
        status = SUCCESS
        if message.sender != message.conversation.sender
          notification_detail = NotificationDetail.new
          notification_detail.create_notification_details(message, current_user, nil)
        end
      end
    end
    render json: { status: status, data: data, errors: errors }
  end
end
