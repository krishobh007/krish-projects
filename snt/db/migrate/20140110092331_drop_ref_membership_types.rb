class DropRefMembershipTypes < ActiveRecord::Migration
  def up
    drop_table :ref_membership_types
  end

  def down
    create_table :ref_membership_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
