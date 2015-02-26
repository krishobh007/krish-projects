require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Queue PreCheckin Reservations"
  task :queue_pre_checkin_reservations => :environment do
    Resque.enqueue(QueuePreCheckinReservations)
  end
end