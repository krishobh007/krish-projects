require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Exports history reservations"
  task :last_month_reservations_export do
  	hotel_id = ENV['hotel_id']
  	month = ENV['month']
  	year = ENV['year']
    Resque.enqueue(LastMonthReservationsExport, hotel_id, month)
  end
end
