class AddIsReservationExportOnToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :is_reservation_export_on, :boolean
  end
end
