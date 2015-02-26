class AddIsEarlyCheckinPurchasedToReservation < ActiveRecord::Migration
  def change
  	add_column :reservations, :is_early_checkin_purchased, :boolean, :default=>0
  end
end
