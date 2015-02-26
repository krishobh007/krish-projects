class CreateBillingGroups < ActiveRecord::Migration
  def change
    create_table :billing_groups do |t|
      t.string :name
      t.string :description
      t.integer :hotel_id
      t.timestamps
    end
  end
end
