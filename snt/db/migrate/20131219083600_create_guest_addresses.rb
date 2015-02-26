class CreateGuestAddresses < ActiveRecord::Migration
  def change
    create_table :guest_addresses do |t|
      t.references :guest_detail, null: false, index: true
      t.string :label
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.boolean :is_primary
      t.string :address_type
      t.string :external_id, null: false
      t.timestamps
    end
  end
end
