class DropEndOfDayDetails < ActiveRecord::Migration
  def change
    drop_table :end_of_day_details
  end
end
