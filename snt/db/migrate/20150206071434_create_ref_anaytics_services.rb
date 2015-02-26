class CreateRefAnayticsServices < ActiveRecord::Migration
  def up
    create_table :ref_analytics_services do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
      t.userstamps
    end 
  end 
end
