class AddAddressTypeToAddress < ActiveRecord::Migration
  def self.up
    change_table :addresses do |t|
      t.references :associated_address, polymorphic: true
    end
  end
end
