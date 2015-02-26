class AddUidToReservationKeys < ActiveRecord::Migration
  def change
  	add_column :reservation_keys, :uid, :string
  	add_column :reservation_keys, :is_inactive, :boolean, :default=>0
  end
end
