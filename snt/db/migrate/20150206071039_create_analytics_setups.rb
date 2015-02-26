class CreateAnalyticsSetups < ActiveRecord::Migration
  def change
    create_table :analytics_setups do |t|
      t.string :analytics_type, null: false
      t.string :product_type, null: false
      t.string :tracking_id, null: false
      t.integer :hotel_id
      t.integer :service_id
      t.timestamps
    end
  end
end
