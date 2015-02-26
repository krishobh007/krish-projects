require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Imports a CSV smartbands file into a smartband table"
  task :smartband_import, [:hotel_id] => :environment do |task, args|
    # Enqueue an instance of the reservation import job for the provided hotel_id
    Resque.enqueue(SmartBandImport, args[:hotel_id])
  end
end
