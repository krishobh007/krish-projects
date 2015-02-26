class AddIsQueuedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_queued, :boolean, :default => false
  end
end
