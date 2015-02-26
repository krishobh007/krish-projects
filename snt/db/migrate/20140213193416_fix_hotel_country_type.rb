class FixHotelCountryType < ActiveRecord::Migration
  def change
    change_column :hotels, :country_id, :integer, null: false
  end
end
