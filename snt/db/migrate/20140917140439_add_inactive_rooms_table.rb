class AddInactiveRoomsTable < ActiveRecord::Migration
  def change
    create_table :inactive_rooms do |t|
      t.references :room
      t.references :ref_service_status
      t.references :maintenance_reason
      t.date :from_date
      t.date :to_date
      t.text :comments
    end
  end
end
