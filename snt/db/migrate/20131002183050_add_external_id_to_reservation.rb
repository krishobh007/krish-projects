class AddExternalIdToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :external_id, :string
  end
end
