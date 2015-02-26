module SeedEndOfDayProcess
  def create_end_of_day_process
    hotel = Hotel.first

    EndOfDayProcess.create(ref_end_of_day_id: 1, is_active: true, hotel_id: hotel.id, process_sequence: 1)
    EndOfDayProcess.create(ref_end_of_day_id: 2, is_active: true, hotel_id: hotel.id, process_sequence: 2)
    EndOfDayProcess.create(ref_end_of_day_id: 3, is_active: true, hotel_id: hotel.id, process_sequence: 3)
    EndOfDayProcess.create(ref_end_of_day_id: 4, is_active: true, hotel_id: hotel.id, process_sequence: 4)
    EndOfDayProcess.create(ref_end_of_day_id: 5, is_active: true, hotel_id: hotel.id, process_sequence: 5)
    EndOfDayProcess.create(ref_end_of_day_id: 6, is_active: true, hotel_id: hotel.id, process_sequence: 6)
    EndOfDayProcess.create(ref_end_of_day_id: 7, is_active: true, hotel_id: hotel.id, process_sequence: 7)
    EndOfDayProcess.create(ref_end_of_day_id: 8, is_active: true, hotel_id: hotel.id, process_sequence: 8)

  end
end