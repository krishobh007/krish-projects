class ViewMappings::HouseKeepMapping
# Calculated Reservation Status Calculations -- Begin

  def self.stay_over_than?(data,  business_date)
    data[:reservation_status] == 'CHECKEDIN' &&
    data[:dept_date] > business_date &&
    data[:arrival_date] < business_date
  end

  def self.arrival_on?(data, business_date)
    data[:reservation_status] == 'RESERVED' &&
    data[:arrival_date] == business_date
  end

  def self.arrived_on?(data, business_date)
    data[:reservation_status] == 'CHECKEDIN' &&
    data[:arrival_date] == business_date
  end

  def self.departed_on?(data, business_date)
    data[:reservation_status] == 'CHECKEDOUT' &&
    data[:dept_date] == business_date
  end

  def self.day_use_on?(data, business_date)
    data[:dept_date] == business_date && data[:arrival_date] == business_date
  end

  def self.early_checkout_than?(data, business_date)
    data[:dept_date] > business_date && data[:reservation_status] == 'CHECKEDOUT'
  end

  def self.due_out_on?(data, business_date)
    data[:reservation_status] == 'CHECKEDIN' &&  data[:dept_date]  == business_date
  end

  def self.no_show?(data)
    data[:reservation_status] == 'NOSHOW'
  end

  def self.mapped_status(data, business_date, current_hotel)
    if stay_over_than?(data, business_date)
      return 'Stayover'

    elsif arrival_on?(data, business_date)
      return 'Arrival'

    elsif arrived_on?(data, business_date) && day_use_on?(data, business_date) && due_out_on?(data, business_date)
      return 'Arrived / Day use / Due out'
    
    elsif arrived_on?(data, business_date)
      return 'Arrived'

    elsif due_out_on?(data, business_date)
      return 'Due out'

    elsif early_checkout_than?(data, business_date) || no_show?(data)
      return 'Not Reserved'

    elsif departed_on?(data, business_date)
      return 'Departed'

    else
      logger.debug "HK_Status - Not defined for #{data[:room_no]} of hotel id - #{current_hotel.id}"
      return 'Not Defined'
    end
  end
# Old data - First Reservation
# new data - Second reservation
  def self.computed_status(old_data, new_data, business_date, current_hotel)
    if (departed_on?(old_data, business_date) && arrived_on?(new_data, business_date) &&
        day_use_on?(new_data, business_date) && (due_out_on?(old_data, business_date) || due_out_on?(new_data, business_date))) ||
        (departed_on?(new_data, business_date) && arrived_on?(old_data, business_date) &&
        day_use_on?(old_data, business_date) && (due_out_on?(old_data, business_date) || due_out_on?(new_data, business_date)))
      return 'Arrived / Day use / Due out / Departed'

      elsif (due_out_on?(old_data, business_date) || due_out_on?(new_data, business_date)) &&
        (arrival_on?(old_data, business_date) || arrival_on?(new_data, business_date))
      return 'Due out / Arrival'

      elsif (departed_on?(old_data, business_date) || departed_on?(new_data, business_date)) &&
        (arrival_on?(old_data, business_date) || arrival_on?(new_data, business_date))
      return 'Departed / Arrival'

      elsif (arrived_on?(old_data, business_date) || arrived_on?(new_data, business_date)) &&
        (departed_on?(old_data, business_date) || departed_on?(new_data, business_date))
      return 'Arrived / Departed'

      elsif (departed_on?(old_data, business_date) || departed_on?(new_data, business_date)) &&
        (due_out_on?(old_data, business_date) || due_out_on?(new_data, business_date))
      return 'Due out / Departed'

      elsif arrived_on?(old_data, business_date) || arrived_on?(new_data, business_date)
      return 'Arrived'

      elsif stay_over_than?(old_data, business_date) || stay_over_than?(new_data, business_date)
      return 'Stayover'

      elsif departed_on?(old_data, business_date) || departed_on?(new_data, business_date)
      return 'Departed'
      else
        logger.debug "HK_Status - Not defined for #{new_data[:room_no]} of hotel id - #{current_hotel.id}"
        return 'Not Defined'
    end
  end
# Calculated Reservation Status Calculations -- END
end
