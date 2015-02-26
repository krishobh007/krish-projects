class AddReservationLastImported < ActiveRecord::Migration
  def change
    add_column :reservations, :last_imported, :datetime
  end
end
