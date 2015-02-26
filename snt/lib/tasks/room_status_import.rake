require 'resque/tasks'
require 'resque_scheduler' 

namespace :pms do
  desc "Imports room status info and updates rooms table"
  task :room_status_import, [:hotel_chain_id] => :environment do |task,args|
    # Enqueue an instance of the room status import job for the provided hotel_chain_id
    Resque.enqueue(RoomStatusImport, args[:hotel_chain_id])
  end
end