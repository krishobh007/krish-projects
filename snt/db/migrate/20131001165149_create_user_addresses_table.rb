class CreateUserAddressesTable < ActiveRecord::Migration
  def change
    create_table :user_addresses do |t|
      t.references :user, index: true
      t.string :type
      t.string :street1
      t.string :street2
      t.string :city
      t.references :state, index: true
      t.string :postal_code
      t.references :country, index: true

      t.timestamps
    end
  end
end
