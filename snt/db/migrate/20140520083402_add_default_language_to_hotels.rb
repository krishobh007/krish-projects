class AddDefaultLanguageToHotels < ActiveRecord::Migration
  def change
    execute("update hotels set language_id=(select id from ref_languages where value = 'EN') where language_id is null")
    change_column :hotels, :language_id, :integer, null: false
  end
end
