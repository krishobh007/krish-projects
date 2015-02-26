class QueuePreCheckinReservationsScheduler
  include Resque::Plugins::UniqueJob

  @queue = :Queue_PreCheckin_Reservations_Scheduler

  # Find all hotels that need to import and schedule the import job
  def self.perform
    begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      Hotel.needs_pre_checkin.each do |hotel|
        Resque.enqueue(QueuePreCheckinReservations, hotel.id)
      end  
    rescue => e
      ExceptionNotifier.notify_exception(e)
    end
  end
end