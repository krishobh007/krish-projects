class RoomNumberImport
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = "Room_Number_Import"

  def self.perform
    begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      Hotel.first.sync_external_room_number
    rescue => e
      ExceptionNotifier.notify_exception(e)  
    end
  end
end
