module SeedWorkTypeAndTasks
  def create_system_work_type
    hotels = Hotel.all

    hotels.each do |hotel|
      next if hotel.is_third_party_pms_configured?

      daily_cleaning = hotel.work_types.find_or_create_by_name_and_is_system('Daily Cleaning', true)

      unless daily_cleaning.nil?
        clean_departures = daily_cleaning.tasks.find_or_create_by_name_and_is_system(
          'Clean Departures',
          true
        )

        clean_stayovers = daily_cleaning.tasks.find_or_create_by_name_and_is_system(
          'Clean Stayovers',
          true
        )

        room_types = hotel.room_types

        # Clear current room types
        clean_departures.room_types.clear
        clean_stayovers.room_types.clear

        # Assign room types
        clean_departures.room_types << room_types
        clean_stayovers.room_types << room_types

        departed_hk_status = Ref::ReservationHkStatus.where(value: 'DEPARTED').first
        stay_over_hk_status = Ref::ReservationHkStatus.where(value: 'STAYOVER').first
        dueout_hk_status = Ref::ReservationHkStatus.where(value: 'DUEOUT').first

        # Mapping HK reservation statuses
        unless clean_departures.ref_reservation_hk_statuses.include?(dueout_hk_status)
          clean_departures.ref_reservation_hk_statuses << dueout_hk_status
        end

        unless clean_departures.ref_reservation_hk_statuses.include?(departed_hk_status)
          clean_departures.ref_reservation_hk_statuses << departed_hk_status
        end

        unless clean_stayovers.ref_reservation_hk_statuses.include?(stay_over_hk_status)
          clean_stayovers.ref_reservation_hk_statuses << stay_over_hk_status
        end

        vacant_fo_status = Ref::FrontOfficeStatus.where(value: 'VACANT').first
        occupied_fo_status = Ref::FrontOfficeStatus.where(value: 'OCCUPIED').first

        # Mapping FO statuses
        clean_departures.front_office_statuses << vacant_fo_status unless clean_departures.front_office_statuses.include?(vacant_fo_status)
        clean_departures.front_office_statuses << occupied_fo_status unless clean_departures.front_office_statuses.include?(occupied_fo_status)

        clean_stayovers.front_office_statuses << occupied_fo_status unless clean_stayovers.front_office_statuses.include?(occupied_fo_status)
      end
    end
  end
end
