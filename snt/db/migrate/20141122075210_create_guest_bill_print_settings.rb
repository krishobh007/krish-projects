class CreateGuestBillPrintSettings < ActiveRecord::Migration
  def up
  	create_table :guest_bill_print_settings do |t|
      t.string :logo_type
      t.boolean :show_hotel_address
      t.text :custom_text_header
      t.text :custom_text_footer
      t.timestamps
  	end
  end

  def down
    drop_table :guest_bill_print_settings
  end
end
