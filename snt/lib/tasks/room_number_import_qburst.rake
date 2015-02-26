require 'resque/tasks'
require 'resque_scheduler' 

namespace :pms_qburst do
  desc "Imports room numbers"
  task :room_number_import => :environment do
    
    #Import room numbers
    
    Hotel.first.sync_external_room_number
    
  end
end