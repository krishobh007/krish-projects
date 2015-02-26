class AddLastReservationFilenameToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :last_reservation_filename, :string
  end
end
