class AddPmsTypeToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :pms_type_id, :integer
  end
end
