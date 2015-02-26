class CreateHotelsRoles < ActiveRecord::Migration
  def change
  	create_table :hotels_roles do |t|
      t.integer :hotel_id, null: false
      t.integer :role_id, null: false
      t.integer :default_dashboard_id, null: false
      t.boolean :is_active, null: false, default: false
  	end
  end
end
