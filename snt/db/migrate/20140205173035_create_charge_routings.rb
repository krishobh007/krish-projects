class CreateChargeRoutings < ActiveRecord::Migration
  def change
    create_table :charge_routings do |t|
      t.references :bill, null: false
      t.integer :to_bill_id,  references: :bill, null: false
      t.references :room
      t.references :charge_code
      t.string :external_routing_instructions, limit: 2000
      t.string :owner_name
      t.references :created_by
      t.references :updated_by
      t.timestamps
    end
  end
end
