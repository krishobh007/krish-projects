class CreatePmsTypes < ActiveRecord::Migration
  def change
    create_table :ref_pms_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
