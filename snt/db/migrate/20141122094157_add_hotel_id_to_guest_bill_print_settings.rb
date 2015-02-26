class AddHotelIdToGuestBillPrintSettings < ActiveRecord::Migration
  def change
    add_column :guest_bill_print_settings, :hotel_id, :integer
  end
end
