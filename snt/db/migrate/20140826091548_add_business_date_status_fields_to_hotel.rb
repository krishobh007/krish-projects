class AddBusinessDateStatusFieldsToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :is_eod_in_progress, :boolean, default: false
    add_column :hotels, :is_eod_manual_started, :boolean, default: false
  end
end
