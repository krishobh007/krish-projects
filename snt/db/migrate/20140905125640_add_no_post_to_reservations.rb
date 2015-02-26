class AddNoPostToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :no_post, :boolean
  end
end
