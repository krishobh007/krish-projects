if @business_date
  json.business_date @business_date.andand.strftime('%Y-%m-%d')
end