class AddMembershipTables < ActiveRecord::Migration
  def change
    create_table :membership_types do |t|
      t.references :chain, index: true
      t.references :hotel, index: true
      t.string :membership_class, limit: 40, null: false
      t.string :membership_type, limit: 40, null: false
      t.references :created_by, null: false
      t.references :updated_by, null: false

      t.timestamps
    end

    create_table :membership_levels do |t|
      t.string :membership_type, limit: 40, null: false
      t.string :membership_level, limit: 40, null: false
      t.boolean :is_inactive
    end
  end
end
