class CreateEarlyCheckinSetups < ActiveRecord::Migration
  def change
    create_table :early_checkin_setups do |t|
      t.float :charge
      t.datetime :start_time
      t.integer :hotel_id
      t.integer :addon_id
      t.timestamps
    end
  end
end
