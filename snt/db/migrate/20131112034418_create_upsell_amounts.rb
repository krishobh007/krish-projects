class CreateUpsellAmounts < ActiveRecord::Migration
  def change
    create_table :upsell_amounts do |t|
      t.integer :level_from
      t.integer :level_to
      t.float :amount
      t.references :hotel
    end
  end
end
