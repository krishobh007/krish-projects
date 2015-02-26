require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Exports future reservations"
  task :upcoming_reservations_export, [:hotel_id] => :environment do |task, args|
    Resque.enqueue(UpcomingReservationsExport, args[:hotel_id])
  end
end