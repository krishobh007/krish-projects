json.arrival_date @reservation.arrival_date.andand.strftime('%b. %d, %Y')
json.departure_date @reservation.dep_date.andand.strftime('%b. %d, %Y')
json.room_type @reservation.current_daily_instance.room_type.andand.room_type_name
json.confirm_no @reservation.confirm_no
json.rate @reservation.current_daily_instance.andand.rate.andand.rate_name
json.rate_amount @reservation.current_daily_instance.andand.rate_amount
json.arrival_time @reservation.arrival_time.andand.in_time_zone(@reservation.hotel.tz_info).andand.strftime('%I:%M %p')