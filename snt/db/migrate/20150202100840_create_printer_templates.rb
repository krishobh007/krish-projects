class CreatePrinterTemplates < ActiveRecord::Migration
  def change
    create_table :printer_templates do |t|
      t.timestamps
      t.text :template, null: false
      t.integer :hotel_id, null: false
      t.string :template_type, null: false
    end
  end
end
