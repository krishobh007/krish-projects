namespace :pms do
  desc "Exports reservation data to a CSV file"
  task :reservation_export do
    require 'csv'
    dir = File.dirname("#{Rails.root}/public/export/res_export_#{Date.today}.csv")
    logger ||= Logger.new('log/res_export.log')
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    file = (dir + "/res_export_#{Date.today}.csv")

    logger.info("Data export file #{file}")
    
    CSV.open(file, "w") do |csv|
      @hotel = Hotel.find(ENV['hotel_id'])
      from_date = Date.parse(ENV['from_date'])
      to_date = Date.parse(ENV['to_date'])
      hotel_reservations = @hotel.reservations
      @reservations = hotel_reservations.checked_out_between(from_date, to_date)
      csv << ["hotel code","first name","last name","room number","reservation number","arrival date","arrival time","departure date","departure time","email address"]  #column head of csv file
      @reservations.each do |reservation|
      csv << [reservation.hotel.code,
              reservation.primary_guest.andand.first_name || reservation.company.andand.account_name || reservation.travel_agent.andand.account_name,
              reservation.primary_guest.andand.last_name,
              reservation.current_daily_instance.andand.room.andand.room_no,
              reservation.confirm_no,
              reservation.arrival_date,
              reservation.arrival_time.andand.in_time_zone(@hotel.tz_info),
              reservation.dep_date,
              reservation.departure_time.andand.in_time_zone(@hotel.tz_info),
              reservation.primary_guest.andand.email
              ] #fields name
      end
    end
  end
end