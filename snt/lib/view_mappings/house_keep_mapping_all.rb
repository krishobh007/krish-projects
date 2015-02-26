class ViewMappings::HouseKeepMappingAll
# This will calculate the reservation status for a room based on date -- Begin

  def self.stay_over_than?(data,  date)
    data[:dept_date] > date &&
    data[:arrival_date] < date
  end

  def self.arrival_on?(data, date)
    data[:arrival_date] == date
  end

  def self.due_out_on?(data, business_date)
    data[:dept_date]  == business_date
  end

  def self.day_use_on?(data, date)
    data[:dept_date] == date && data[:arrival_date] == date
  end

  def self.early_checkout_than?(data, date)
    data[:dept_date] > date
  end

  def self.no_show?(data)
    data[:reservation_status] == 'NOSHOW'
  end

  def self.mapped_status(data, date, current_hotel)
    if stay_over_than?(data, date)
      return 'Stayover'

    elsif arrival_on?(data, date)
      return 'Arrival'

    elsif arrival_on?(data, date) && day_use_on?(data, date) && departed_on?(data, date)
      return 'Arrived / Day use / Departed'

    elsif early_checkout_than?(data, date) || no_show?(data)
      return 'Not Reserved'

    elsif due_out_on?(data, date)
      return 'Due out'

    else
      logger.debug "HK_Status - Not defined for #{data[:room_no]} of hotel id - #{current_hotel.id}"
      return 'Not Defined'
    end
  end
# Old data - First Reservation
# new data - Second reservation
  def self.computed_status(old_data, new_data, date, current_hotel)
    if (due_out_on?(old_data, date) && arrival_on?(new_data, date) &&
        day_use_on?(new_data, date) && (due_out_on?(old_data, date) || due_out_on?(new_data, date))) ||
        (due_out_on?(new_data, date) && arrived_on?(old_data, date) &&
        day_use_on?(old_data, date) && (due_out_on?(old_data, date) || due_out_on?(new_data, date)))
      return 'Arrival / Day Use / Departed'

      elsif (due_out_on?(old_data, date) || due_out_on?(new_data, date)) &&
        (arrival_on?(old_data, date) || arrival_on?(new_data, date))
      return 'Due out / Arrival'

      elsif (arrival_on?(old_data, date) || arrival_on?(new_data, date)) &&
        (due_out_on?(old_data, date) || due_out_on?(new_data, date))
      return 'Arrived / Departed'

      elsif (due_out_on?(old_data, date) || due_out_on?(new_data, date))
      return 'Due out'
      
      elsif stay_over_than?(old_data, date) || stay_over_than?(new_data, date)
      return 'Stayover'

      else
        logger.debug "HK_Status - Not defined for #{new_data[:room_no]} of hotel id - #{current_hotel.id}"
        return 'Not Defined'
    end
  end
# This will calculate the reservation status for a room based on date -- END
end
