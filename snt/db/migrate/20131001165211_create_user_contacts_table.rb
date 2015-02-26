class CreateUserContactsTable < ActiveRecord::Migration
  def change
    create_table :user_contacts do |t|
      t.references :user, index: true
      t.string :type
      t.string :value

      t.timestamps
    end
  end
end
