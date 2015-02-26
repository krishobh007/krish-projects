class CreateUserMemberships < ActiveRecord::Migration
  def change
    create_table :user_memberships do |t|
      t.references :user
      t.string :memebership_type
      t.integer :membership_card_number
      t.date :membership_expiry_date
      t.string :membership_level
      t.string :membership_class
      t.string :card_name
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
