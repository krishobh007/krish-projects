class AddReservationOnlyToAddons < ActiveRecord::Migration
  def change
    add_column :addons, :is_reservation_only, :boolean, default: false
  end
end
