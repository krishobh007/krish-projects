class ModifyExternalReferences < ActiveRecord::Migration
  def change
    create_table :ref_external_reference_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    change_table :external_references do |t|
      t.references :associated, polymorphic: true, null: false
      t.references :reference_type, null: false
      t.remove :hotel_id
      t.remove :external_seg_no
      t.remove :pms_type_id
      t.remove :reference_type
    end

    rename_column :external_references, :external_value, :description
  end
end
