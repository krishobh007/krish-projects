class AddColumnsToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :created_by_id, :integer
    add_column :preferences, :updated_by_id, :integer
  end
end
