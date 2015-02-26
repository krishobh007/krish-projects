require 'resque/tasks'
require 'resque_scheduler'

namespace :pms do
  desc "Updates hotel business date"
  task :update_hotel_business_date => :environment do
    Resque.enqueue(UpdateHotelBusinessDate)
  end
end