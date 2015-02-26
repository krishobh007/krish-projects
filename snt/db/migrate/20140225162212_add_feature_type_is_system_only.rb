class AddFeatureTypeIsSystemOnly < ActiveRecord::Migration
  def change
    add_column :feature_types, :is_system_only, :boolean, null: false, default: false
    execute("update feature_types set is_system_only = 1 where value in ('ELEVATOR', 'FLOOR', 'SMOKING')")
  end
end
