class AddTimeStampsToPreReservations < ActiveRecord::Migration
  def change
    add_column :pre_reservations, :created_at, :datetime
    add_column :pre_reservations, :updated_at, :datetime
  end
end
