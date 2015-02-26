class AddIsPreCheckinToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_pre_checkin, :boolean, default: false
  end
end
