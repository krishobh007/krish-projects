json.data @work_types do |work_type|
json.id work_type.id
json.name work_type.name
work_sheets = work_type.andand.work_sheets.where("date = ? and user_id IS NOT NULL", @business_date)
  json.employees work_sheets do |work_sheet|
    user = work_sheet.andand.user
    json.id user ? user.id : nil
    json.name user ? user.andand.full_name : nil
  end
end