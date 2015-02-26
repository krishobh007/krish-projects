class CreateHotelEmailTemplates < ActiveRecord::Migration
  def change
    create_table :hotel_email_templates do |t|
      t.integer :hotel_id
      t.integer :email_template_id
      t.timestamps
    end
  end
end
