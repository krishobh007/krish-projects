module SeedMaidShifts
  
  def create_maid_shift
    hotels = Hotel.all
    hotels.each do |hotel|
      # Skip iteration if hotel is PMS Connected
      next if hotel.is_third_party_pms_configured?
      # Create Full time shift for the hotel
      hotel.shifts.find_or_create_by_name_and_is_system('Full Shift', true)
      # Create Half time shift for the hotel
      hotel.shifts.find_or_create_by_name_and_is_system('Half Shift', true)
    end
  end
  
end