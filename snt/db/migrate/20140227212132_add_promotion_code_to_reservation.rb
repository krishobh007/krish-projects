class AddPromotionCodeToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :promotion_code, :string
  end
end
