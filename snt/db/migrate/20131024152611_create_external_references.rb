class CreateExternalReferences < ActiveRecord::Migration
  def change
    create_table :external_references do |t|
      t.string :external_system, limit: 80, null: false
      t.string :reference_type, limit: 40, null: false
      t.string :value, limit: 45, null: false
      t.string :external_value, limit: 45, null: false
      t.string :external_seg_no, limit: 20

      t.references :chain, null: false
      t.references :hotel, null: false

      t.timestamps
    end
  end
end
