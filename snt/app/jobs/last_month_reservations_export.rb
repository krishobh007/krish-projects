require 'csv'

class LastMonthReservationsExport
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Last_Month_Reservations_Export

  def self.perform(hotel_id, month=nil, year=nil)
  	require 'csv'
    dir = File.dirname("#{Rails.root}/public/export/#{hotel_id}/last_month_reservations_export_#{Date.today}.csv")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    file = (dir + "/last_month_reservations_export_#{Date.today}.csv")
    month = Date.today.month - 1 if !month
    year = Date.today.year if !year

    to_date = Date.parse("#{Date.civil(year, month, -1)}")#last day of month
    from_date = Date.parse("#{year}-#{month}-01") #first day of month
    
    logger.info("Data export file #{file}")
    CSV.open(file, "w") do |csv|
      @hotel = Hotel.find(hotel_id)
      reservations = @hotel.reservations.where('dep_date >= ? AND dep_date <= ?', from_date, to_date)
      cancelled_reservations = reservations.with_status(:CANCELLED)
      no_show_reservations = reservations.with_status(:NOSHOW)
      checked_out_reservations = reservations.with_status(:CHECKEDOUT)
      @reservations = cancelled_reservations + no_show_reservations + checked_out_reservations
      if !@reservations.empty?
        csv << ["hotel code","first name","last name","room number", "room type", "reservation number","arrival date","arrival time","departure date","departure time","rate code", "rate amount for total stay", "status"]  #column head of csv file
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
                reservation.get_total_stay_amount,
                reservation.status.value
                ] #fields name
        end
      else
        csv << ["No reservations found"]
      end 
    end
    HotelMailer.send_reservations_export(@hotel, file).deliver!
  end

end