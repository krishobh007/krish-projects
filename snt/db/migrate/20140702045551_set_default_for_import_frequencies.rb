class SetDefaultForImportFrequencies < ActiveRecord::Migration
  def change
    change_column :hotels, :day_import_freq, :integer, default: 5
    change_column :hotels, :night_import_freq, :integer, default: 5
  end
end
