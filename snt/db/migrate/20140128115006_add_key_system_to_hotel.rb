class AddKeySystemToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :key_system_id, :integer
  end
end
