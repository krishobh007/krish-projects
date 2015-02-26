class AddLanguageIdToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :language_id, :integer
  end
end
