class NotificationDetail < ActiveRecord::Base
  attr_accessible :notification_id, :notification_type, :message, :additional_data, :notification_section

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_and_belongs_to_many :users, join_table: 'users_notification_details'
  belongs_to :notification, polymorphic: true
  validates :notification_id, :notification_type, :message, :notification_section, presence: true

  validates :notification_id, uniqueness: { scope: [:notification_type, :notification_section], case_sensitive: false }

  def create_notification_details(model_object, user, group_id)
    case model_object.class.name
    when Setting.notification_type[:post]
      notification_type = Setting.notification_type[:post]
      if group_id.present?
        notification_message = 'posted in My Group'
        notification_section = Setting.notification_section_text[:my_group]
      else
        notification_message = 'posted in Social Lobby'
        notification_section = Setting.notification_section_text[:social_lobby]
      end
    when Setting.notification_type[:comment]
      notification_type = Setting.notification_type[:comment]
      info = set_comment_info(model_object, user)
      notification_message = info[:section_message]
      notification_section = info[:section_type]

    when Setting.notification_type[:message]
      notification_type  = Setting.notification_type[:message]
      append_also = (model_object.conversation.messages.count > 1) ? 'also ' : ''
      notification_message = "#{append_also} responded to your conversation"
      notification_section = Setting.notification_section_text[:text_to_staff]
      #TODO - rest to do
    else
      notification_type = ''
      notification_message = ''
      notification_section = ''
    end

    notification_detail = NotificationDetail.create(notification_id: model_object.id,
                                                    notification_type: notification_type,
                                                    message: "#{user.detail.andand.full_name} #{notification_message}" ,
                                                    notification_section: notification_section)
    if !notification_detail.errors.empty?
      logger.debug notification_detail.errors.full_messages
    else
      if model_object.class.name == Setting.notification_type[:post]
        if model_object.reservation.present?
          if (model_object.reservation.arrival_date <= model_object.reservation.hotel.active_business_date) &&
              (model_object.reservation.dep_date >= model_object.reservation.hotel.active_business_date)
            if group_id.present?
              group_user_ids =  []
              group = Group.find(group_id)
              group_reservation_id_list = group.reservation_daily_instances.pluck(:reservation_id).uniq
              group_reservation_id_list.each do |reservation_id|
                reservation = Reservation.find(reservation_id)
                if reservation.primary_guest.andand.user_id.present?
                  group_user_ids << reservation.primary_guest.andand.user_id
                  group_user_ids = group_user_ids.uniq
                end
              end

              group_user_ids.each do |group_user_id|
                # The user who posts in my group need not receive push notifications
                if group_user_id != user.id
                  notify_users(group_user_id, notification_detail)
                end
              end

            else
              user_id_list = model_object.hotel.reservations.where('? BETWEEN arrival_date and dep_date', model_object.hotel.active_business_date)
                .joins(:guest_details).where('user_id IS NOT NULL').pluck(:user_id).uniq

              user_id_list.each do |user_id|
                # The user who posts in social lobby need not receive push notifications
                if user_id != user.id
                  notify_users(user_id, notification_detail)
                end
              end
            end

          end
        end

      elsif model_object.class.name == Setting.notification_type[:message]
        create_conversation_message_users_notification(model_object, notification_detail)

      elsif model_object.class.name == Setting.notification_type[:comment]

        if model_object.commentable_type == Setting.notification_type[:post]
          should_notify = model_object.commentable.user.notification_preference ? model_object.commentable.user.notification_preference.andand.response_to_post : true
        elsif model_object.commentable_type == Setting.notification_type[:review]
          should_notify = model_object.commentable.user.notification_preference ? model_object.commentable.user.notification_preference.andand.response_to_review : true
        end

        if model_object.commentable.user_id != user.id
          UsersNotificationDetail.create(user_id: model_object.commentable.user_id,
                                         notification_detail_id: notification_detail.id ,
                                         is_read: false,
                                         is_pushed: false,
                                         should_notify: should_notify,
                                         notification_channel: Setting.notification_channel[:push_notification])
        end
      end
    end
  end

  def set_comment_info(comment, user)
    info = {}
    append_also = (comment.commentable.comments.count > 1) ? 'also ' : ''
    case comment.commentable_type
    when Setting.notification_type[:post]
      if comment.commentable.group_id.present?
        info[:section_message] = "#{append_also}responded to your post in My Group"
        info[:section_type] = Setting.notification_section_text[:my_group]
      else
        info[:section_message] = "#{append_also}responded to your post in Social Lobby"
        info[:section_type] = Setting.notification_section_text[:social_lobby]
      end
    when Setting.notification_type[:review]
      info[:section_message] = "#{append_also}responded to your Review"
      info[:section_type] = Setting.notification_section_text[:review]
    else
      info[:section_message] = ''
      info[:section_type] = ''
    end
    info
  end

  def self.create_reservation_notification(reservation, notification_section, alert_time,is_read=false,is_pushed=false)
    create_notification = true
    notification_detail = nil
    linked_guest_detail = reservation.guest_details.where('user_id IS NOT NULL').first
    if linked_guest_detail.present?

      zest_user = linked_guest_detail.user

      if notification_section ==  Setting.notification_section_text[:check_in]
        alert_time = nil
        notify_message = reservation.hotel.settings.checkin_alert_message
        notify_message = notify_message.gsub('@FIRSTNAME', linked_guest_detail.first_name.to_s)
                          .gsub('@LASTNAME', linked_guest_detail.last_name.to_s)
                          .gsub('@TITLE', linked_guest_detail.title.to_s)
      elsif  notification_section == Setting.notification_section_text[:check_out] || notification_section == Setting.notification_section_text[:beacon_checkout]
        notify_message = (reservation.hotel.late_checkout_available? && !reservation.is_opted_late_checkout) ?  "Late Check Out's Available, Click To Learn More" : "Its getting time for checkout"
      end

      if (notification_section == Setting.notification_section_text[:check_in]) && (!reservation.hotel.settings.checkin_alert_is_on)
        create_notification = false
      end

      if create_notification
        notification_detail = NotificationDetail.create(notification_id: reservation.id,
                                                        notification_type: Setting.notification_type[:reservation],
                                                        message: notify_message,
                                                        notification_section: notification_section)
        if !notification_detail.errors.empty?
          logger.debug notification_detail.errors.full_messages
        else
          UsersNotificationDetail.create(user_id: zest_user.id,
                                         notification_detail_id: notification_detail.id,
                                         is_read: is_read,
                                         is_pushed: is_pushed,
                                         should_notify: true, alert_time: alert_time,
                                         notification_channel: Setting.notification_channel[:push_notification])
        end
      end
    end
    notification_detail
  end

  def notify_users(user_id, notification_detail)
    notify_user = User.find(user_id)

    should_notify = notify_user.notification_preference ? notify_user.notification_preference.andand.new_post : true

    UsersNotificationDetail.create(user_id: notify_user.id,
                                   notification_detail_id: notification_detail.id ,
                                   is_read: false,
                                   is_pushed: false,
                                   should_notify: should_notify,
                                   notification_channel: Setting.notification_channel[:push_notification])
  end

  def create_conversation_message_users_notification(message, notification_detail)
    message.recipients.each do |notify_user|
      UsersNotificationDetail.create(user_id: notify_user.id,
                                     notification_detail_id: notification_detail.id,
                                     is_read: false,
                                     is_pushed: false,
                                     should_notify: notify_user.notification_preference ? notify_user.notification_preference.alert_text_to_staff : false,
                                     notification_channel: Setting.notification_channel[:push_notification])
    end
  end

  def self.create_campaign_notification(campaign, reservation)
    linked_guest_detail = reservation.guest_details.where('user_id IS NOT NULL').first
    if linked_guest_detail.present?
      zest_user = linked_guest_detail.user
      alert_time = DateTime.parse(Date.today.to_s + ' ' + campaign.time_to_send).strftime("%Y-%m-%d %H:%M:%S")
      notification_detail = NotificationDetail.find_by_notification_id_and_notification_type(campaign.id, Setting.notification_type[:campaign])
      notification_detail = NotificationDetail.create!(notification_id: campaign.id,
                                                        notification_type: Setting.notification_type[:campaign],
                                                        message: campaign.subject,
                                                        additional_data: campaign.body,
                                                        notification_section: campaign.campaign_type.value) if !notification_detail
      if !notification_detail.errors.empty?
        logger.debug notification_detail.errors.full_messages
      else
        UsersNotificationDetail.create!(user_id: zest_user.id,
                                     notification_detail_id: notification_detail.id,
                                     is_read: false,
                                     is_pushed: false,
                                     alert_time: campaign.is_recurring ? alert_time : Time.now,
                                     should_notify: true,
                                     notification_channel: Setting.notification_channel[:push_notification])
      end
    end
  end
end