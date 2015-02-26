class AddFloorNumberToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :floor_id, :integer
  end
end
