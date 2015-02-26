class NotificationSender
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Notifications

  def self.perform
      logger.debug "notification resque job"
      begin
        # Work around for the MySQL server has gone away error
        ActiveRecord::Base.verify_active_connections!
        notifications = UsersNotificationDetail.where("notification_channel =?  AND is_pushed=false",Setting.notification_channel[:push_notification])
        notifications.each do  |user_notification|
        is_alert_time = true
        if user_notification.alert_time.present?
          is_alert_time = (user_notification.alert_time <= Time.now.utc) ? true : false
        else
          is_alert_time = true
        end

        if(!user_notification.is_pushed && !user_notification.is_read && user_notification.should_notify && is_alert_time)
          if user_notification.user.notifying_device_details.present?
               user_notification.user.notifying_device_details.each do |device|
               if device.device_type == 'iOS'
                  logger.debug " ** sending IOS notification **"
                  note = Grocer::Notification.new(
                  device_token: device.registration_id,
                  alert: "#{user_notification.notification_detail.notification_section} : #{user_notification.notification_detail.message}",
                  custom: { "notification_id" => "#{user_notification.notification_detail.id}" }
                  )
                  pushNotifier = Grocer.pusher(certificate: "#{Rails.root}/certs/ios_notifications/Zest.pem", passphrase: "qburst")
                  logger.debug " ** pushing IOS notification - #{note}"
                  response =  pushNotifier.push(note)
                  logger.debug " ** pushed IOS notification and response is #{response}"
                  user_notification.update_attributes(:is_pushed => true)
                elsif device.device_type == 'Android'
                  api_key = "AIzaSyCwtHMrH-3jgLazqrYdk7nrBctLKSYid80"
                  gcm = GCM.new(api_key)
                  registration_ids = [device.registration_id]
                  notification = "{\"message\": \"#{user_notification.notification_detail.notification_section} : #{user_notification.notification_detail.message}\", \"notification_id\": \"#{user_notification.notification_detail.id}\"}"
                  options = {data: {notification_data: notification}}
                  response = gcm.send_notification(registration_ids, options)
                  logger.debug "response android is  #{response[:status_code]}"
                  user_notification.update_attributes(:is_pushed => true)
              end
           end
         end
        end
      end  
      rescue => e
        ExceptionNotifier.notify_exception(e)
      end
    end
  end
