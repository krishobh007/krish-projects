class RemoveHotelIdFromEmailTemplates < ActiveRecord::Migration
   def change
    remove_index :email_templates, :title_and_hotel_id
    remove_column :email_templates, :hotel_id
  end
end
