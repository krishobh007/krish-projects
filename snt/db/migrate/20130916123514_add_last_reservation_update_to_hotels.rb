class AddLastReservationUpdateToHotels < ActiveRecord::Migration
  def up
    add_column :hotels, :last_reservation_update, :datetime
  end

  def down
    remove_column :hotels, :last_reservation_update
  end
end
