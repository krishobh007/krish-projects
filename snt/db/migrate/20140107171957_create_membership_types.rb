class CreateMembershipTypes < ActiveRecord::Migration
  def change
    create_table :membership_types do |t|
      t.string :value
      t.integer :membership_class_id
      t.integer :property_id
      t.string :property_type

      t.timestamps
    end
  end
end
