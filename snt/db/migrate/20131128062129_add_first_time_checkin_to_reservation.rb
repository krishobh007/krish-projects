class AddFirstTimeCheckinToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :is_first_time_checkin, :boolean, default: true
  end
end
