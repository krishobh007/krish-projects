module SeedNotificationDetails
  def create_notification_details
    NotificationDetail.create(notification_id: 2, notification_type: 'Review', message: 'John Smith responded to your review', notification_section: 'HOTEL REVIEWS')
  end
end
