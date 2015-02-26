require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Checkin push notification"
  task :checkin_notifier => :environment do
    Resque.enqueue(CheckinNotifier)
  end
end