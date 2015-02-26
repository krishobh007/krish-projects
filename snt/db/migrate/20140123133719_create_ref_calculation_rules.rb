class CreateRefCalculationRules < ActiveRecord::Migration
  def change
    create_table :ref_calculation_rules do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
   end
end
