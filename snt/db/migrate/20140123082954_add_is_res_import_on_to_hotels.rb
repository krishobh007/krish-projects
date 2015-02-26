class AddIsResImportOnToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :is_res_import_on, :boolean, null: false, default: false
  end
end
