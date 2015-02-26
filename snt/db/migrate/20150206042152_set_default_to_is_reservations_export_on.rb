class SetDefaultToIsReservationsExportOn < ActiveRecord::Migration
   def change
    change_column :hotels, :is_reservation_export_on, :boolean, default: false, null: false
  end
end