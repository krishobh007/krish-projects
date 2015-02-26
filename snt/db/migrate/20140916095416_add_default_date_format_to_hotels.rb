class AddDefaultDateFormatToHotels < ActiveRecord::Migration
  def change
    execute "UPDATE hotels SET default_date_format_id=1 WHERE default_date_format_id IS NULL;" 
  end
end
