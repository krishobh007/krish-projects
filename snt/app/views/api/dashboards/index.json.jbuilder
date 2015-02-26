json.guests do 
  json.checking_in @checking_in_count
  json.in_house @in_house_count
  json.checking_out @checking_out_count
  json.vip @vip_checkin_count
  json.pre_check_in @pre_checkin_count
  json.is_pre_checkin_only @is_precheckin_only
end
json.occupancy do
  if @default_dashboard  === :MANAGER || @default_dashboard  === :FRONT_DESK
    json.today @occupancy_today
    json.tomorrow @occupancy_tomorrow
    json.day_after_tomorrow @occupancy_day_after_tomorrow
    json.current_month @occupancy_current_month
    json.current_year @occupancy_current_year
  elsif @default_dashboard  === :HOUSEKEEPING
    json.arrivals @arrivals
    json.stayover @stay_over
    json.departures @departures 
  end  
end
json.upsell do 
  json.target @upsell_target
  json.amount @actual_upsell
end 
json.rooms do
  json.occupied @total_occupied_rooms 
  json.vacant_ready @total_vacant_ready
  json.vacant_not_ready @total_vacant_not_ready_rooms_count 
  json.out_of_order @out_of_order_rooms_count
  json.stays_dirty @stay_over_dirty_rooms_count
  json.stays_clean @stay_over_clean_room_count
  json.departure_dirty @dirty_due_out_rooms_count
  json.departure_clean @clean_due_out_rooms_count
end
json.adr do 
  json.today @adr_for_today
  json.tomorrow @adr_for_tomorrow
  json.day_after_tomorrow @adr_for_day_after_tomorrow
  json.current_month @adr_for_current_month
  json.current_year @adr_for_current_year

end

json.rate_of_day do 
  json.today do 
    if @today
      json.name @today[:rate].andand.rate_name
      json.amount @today[:amount]
    else
      {}
    end
  end
  json.tomorrow do 
    if @tomorrow
      json.name @tomorrow[:rate].andand.rate_name
      json.amount @tomorrow[:amount]
    else
      {}
    end
  end
  json.day_after_tomorrow do 
    if @day_after_tomorrow
      json.name @day_after_tomorrow[:rate].andand.rate_name
      json.amount @day_after_tomorrow[:amount]
    else
      {}
    end
  end
end