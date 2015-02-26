class CreateChargeGroups < ActiveRecord::Migration
  def change
    create_table :charge_groups do |t|
      t.string :charge_group
      t.string :description
      t.references :hotel
      t.timestamps
    end
  end
end
