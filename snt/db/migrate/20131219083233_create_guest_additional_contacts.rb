class CreateGuestAdditionalContacts < ActiveRecord::Migration
  def change
    create_table :guest_additional_contacts do |t|
      t.references :guest_detail, null: false, index: true
      t.string :contact_type
      t.string :value
      t.string :label
      t.string :external_id, bull: false
      t.timestamps
    end
  end
end
