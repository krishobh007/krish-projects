class AddCreatorIdAndUpdatorIdToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :creator_id, :integer
    add_column :reservations, :updator_id, :integer
  end
end
