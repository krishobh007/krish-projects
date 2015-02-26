require 'resque/tasks'
require 'resque_scheduler' 

namespace :pms_qburst do
  desc "Imports room status info and updates rooms table in qburst environment"
  task :room_status_import, [:hotel_chain_id] => :environment do |task,args|
    
    chain = HotelChain.find(args[:hotel_chain_id])
      
      chain.hotels.each do |hotel|        
        if hotel.pms_type
          Room.sync_external_room_status(hotel.id, '', '')
        end
      end
  end
end