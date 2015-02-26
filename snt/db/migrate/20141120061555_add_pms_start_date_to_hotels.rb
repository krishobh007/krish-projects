class AddPmsStartDateToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :pms_start_date, :date
  end
end
