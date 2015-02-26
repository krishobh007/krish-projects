class RenameRestrictions < ActiveRecord::Migration
  def change
    rename_table :restrictions, :room_rate_restrictions
  end
end
