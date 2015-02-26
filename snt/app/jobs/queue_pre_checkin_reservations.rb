class QueuePreCheckinReservations
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Queue_PreCheckin_Reservations
  def self.perform(hotel_id)
    logger.debug  '*****   Started Queue PreCheckin Reservations Job *****'

    begin
    # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      hotel = Hotel.find(hotel_id)

      response = {}
      logger.debug "== Is Pre Checkin Only is #{hotel.settings.is_pre_checkin_only} for hotel_id #{hotel.id}=="

      if hotel.settings.queue_prior_to_arrival.present?
        reservations_to_queue = Reservation.pre_checkin_list_not_queued(hotel_id).where('arrival_time IS NOT NULL')

        reservations_to_queue.each do |reservation|
          if Time.now.utc + hotel.settings.queue_prior_to_arrival.to_i.minutes >= reservation.arrival_time
            # Sent to queue if check in action is  sent_to_queue
            if hotel.settings.checkin_action == "sent_to_queue"
              #Then queue the reservation
              if hotel.is_third_party_pms_configured?
                reservation_api = ReservationApi.new(hotel.id)
                response = reservation_api.queue_reservation(reservation.external_id, "true")
                queue_in_snt = response[:status]
              else
              queue_in_snt = true
              end
              if queue_in_snt
                reservation.is_queued = true
                reservation.put_in_queue_updated_at = Time.now.utc
                logger.debug "== Reservation #{reservation.confirm_no} queued =="
                reservation.save!
              end
            elsif hotel.settings.checkin_action == "auto_checkin"
              begin
                if hotel.can_run_automatic_checkin?
                  # Automatically checkin guest
                  checkin_result = reservation.checkin_automatically
                end
              rescue Exception => ex
                puts ex
              end
            end
          else
            logger.debug "== Time to queue : #{Time.now.utc + hotel.settings.queue_prior_to_arrival.to_i.minutes} -- Arrival Time: #{reservation.arrival_time}  =="
            logger.debug "== #{reservation.confirm_no} will be queued only at the time set =="
          end
        end
      end
    rescue => e
      ExceptionNotifier.notify_exception(e)
    end
  end
end
