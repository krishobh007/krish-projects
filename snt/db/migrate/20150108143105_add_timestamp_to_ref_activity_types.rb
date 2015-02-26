class AddTimestampToRefActivityTypes < ActiveRecord::Migration
  def change
  	add_column :ref_activity_types, :created_at, :datetime
  	add_column :ref_activity_types, :updated_at, :datetime
  end
end
