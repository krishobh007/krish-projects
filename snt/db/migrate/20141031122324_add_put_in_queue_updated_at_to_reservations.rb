class AddPutInQueueUpdatedAtToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :put_in_queue_updated_at, :datetime
  end
end
