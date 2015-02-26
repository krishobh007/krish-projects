class PreReservationScheduler
  include Resque::Plugins::UniqueJob

  @queue = :Pre_Reservation_Scheduler

  # Remove expired blocked rooms which are comes from webbooking.
  def self.perform
    begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      logger.debug 'Removing expired pre_reservations '
      pre_reservations = PreReservation.all
      pre_reservations.each do |pre_reservation|
        if Time.now.utc >= pre_reservation.updated_at + 20.minutes
          pre_reservation.delete
        end
      end
      logger.debug 'Deleted Records from pre_reservations table Successfully'
    rescue => e
      ExceptionNotifier.notify_exception(e)
      logger.warn "Error in Pre_Reservation_Scheduler job - #{e}"
    end
  end
end
