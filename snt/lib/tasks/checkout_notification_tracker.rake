require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Checkout push notification"
  task :checkout_notifier => :environment do
    Resque.enqueue(CheckoutNotifier)
  end
end