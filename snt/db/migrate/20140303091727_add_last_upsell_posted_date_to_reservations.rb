class AddLastUpsellPostedDateToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :last_upsell_posted_date, :date
  end
end
