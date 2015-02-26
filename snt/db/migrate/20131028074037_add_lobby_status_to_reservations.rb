class AddLobbyStatusToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :lobby_status, :boolean, default: false
  end
end
