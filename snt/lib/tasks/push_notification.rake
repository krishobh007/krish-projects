require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "push notification"
  task :notification_pusher => :environment do
    Resque.enqueue(NotificationSender)
  end
end