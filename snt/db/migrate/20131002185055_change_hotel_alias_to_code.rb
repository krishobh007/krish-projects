class ChangeHotelAliasToCode < ActiveRecord::Migration
  def change
    rename_column :hotels, :alias, :code
  end
end
