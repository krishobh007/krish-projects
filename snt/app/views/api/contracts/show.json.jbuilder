json.contracted_rate_selected @rate.based_on_rate_id
json.selected_symbol @rate.based_on_value > 0 ? "+" : "-" if @rate.based_on_value
json.selected_type @rate.based_on_type
json.rate_value @rate.based_on_value.to_i.abs
json.call(@rate, :rate_name, :begin_date, :end_date, :is_fixed_rate, :is_rate_shown_on_guest_bill)

json.total_contracted_nights @rate.contract_nights.sum(:no_of_nights)

json.statistics do
  json.booked_nights 0
  json.total_nights 0
  json.total_stays 0
  json.total_revenue number_with_precision(0, precision: 2)
  json.average_rate number_with_precision(0, precision: 2)
end

json.occupancy @rate.contract_nights do |contract_night|
  json.month contract_night.month_year.strftime("%b")
  json.year contract_night.month_year.strftime("%Y")
  json.contracted_occupancy contract_night.no_of_nights
  json.actual_occupancy 0
end
