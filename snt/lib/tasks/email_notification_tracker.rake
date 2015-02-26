require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Checkout Email notification"
  task :checkout_email_notifier => :environment do
    Resque.enqueue(EmailNotificationSender)
  end
end