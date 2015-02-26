class MembershipTypeDescriptionNotNull < ActiveRecord::Migration
  def change
    execute 'update membership_types set description = value where description is null'
    change_column :membership_types, :description, :string, null: false
  end
end
