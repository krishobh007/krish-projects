class AddHotelIdToPaymentTypes < ActiveRecord::Migration
  def change
    add_column :payment_types, :hotel_id, :integer
  end
end
