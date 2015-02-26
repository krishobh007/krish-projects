class AddHotelExternalReferencesImportColumns < ActiveRecord::Migration
  def change
    add_column :hotels, :is_external_references_import_on, :boolean, null: false, default: false
    add_column :hotels, :external_references_import_freq, :integer
    add_column :hotels, :last_external_references_update, :datetime
    add_column :hotels, :last_external_references_filename, :string
  end
end
