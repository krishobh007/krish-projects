require 'csv'

class UpcomingReservationsExport
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Upcoming_Reservations_Export

  def self.perform(hotel_id)
  	require 'csv'
    dir = File.dirname("#{Rails.root}/public/export/#{hotel_id}/upcoming_reservations_export_#{Date.today}.csv")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    file = (dir + "/upcoming_reservations_export_#{Date.today}.csv")
    
    logger.info("Data export file #{file}")
    CSV.open(file, "w") do |csv|
      @hotel = Hotel.find(hotel_id)
      @reservations = @hotel.reservations.with_status(:RESERVED).upcoming_reservations_including_todays(Date.today) 
      csv << ["hotel code","first name","last name","room number", "room type", "reservation number","arrival date","arrival time","departure date","departure time","rate code", "rate amount for total stay"]  #column head of csv file
      @reservations.each do |reservation|
        csv << [reservation.hotel.code,
              reservation.primary_guest.andand.first_name || reservation.company.andand.account_name || reservation.travel_agent.andand.account_name,
              reservation.primary_guest.andand.last_name,
              reservation.current_daily_instance.andand.room.andand.room_no,
              reservation.current_daily_instance.andand.room.andand.room_type.andand.room_type,
              reservation.confirm_no,
              reservation.arrival_date,
              reservation.arrival_time.andand.in_time_zone(@hotel.tz_info),
              reservation.dep_date,
              reservation.departure_time.andand.in_time_zone(@hotel.tz_info),
              reservation.current_daily_instance.andand.rate.andand.rate_code,
              reservation.get_total_stay_amount
              ] #fields name
      end
    end
    HotelMailer.send_reservations_export(@hotel, file).deliver!
  end

end