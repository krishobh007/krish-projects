class AddRestrictionTypeEditable < ActiveRecord::Migration
  def change
    add_column :ref_restriction_types, :editable, :boolean, null: false, default: false
    execute("update ref_restriction_types set editable = true where value in ('DEPOSIT_REQUESTED', 'CANCEL_PENALTIES', 'LEVELS')")
  end
end
