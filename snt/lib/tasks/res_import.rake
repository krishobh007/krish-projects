require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Imports a CSV reservation file into a reservations table"
  task :res_import, [:hotel_id] => :environment do |task, args|
    # Enqueue an instance of the reservation import job for the provided hotel_id
    Resque.enqueue(ReservationImport, args[:hotel_id])
  end
end
