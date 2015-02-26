class RemoveDescriptionFromReservationStatuses < ActiveRecord::Migration
  def change
    remove_column :ref_reservation_statuses, :description
  end
end
