class AddIsUpsellAppliedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_upsell_applied, :boolean, default: false
  end
end
