class AddAssoicatedAddressToGuestAdditionalContact < ActiveRecord::Migration
  def change
     change_table :guest_additional_contacts do |t|
      t.references :associated_address, polymorphic: true
    end
  end
end
