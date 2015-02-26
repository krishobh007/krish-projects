class CreateGuestMemberships < ActiveRecord::Migration
  def change
    create_table :guest_memberships do |t|
      t.references :guest_detail, null: false, index: true
      t.string :membership_card_number
      t.date :membership_expiry_date
      t.string :name_on_card
      t.date :membership_start_date
      t.string :external_id
      t.references :membership_level
      t.integer :membership_type_id
      t.integer :membership_class_id
      t.timestamps
    end
  end
end
