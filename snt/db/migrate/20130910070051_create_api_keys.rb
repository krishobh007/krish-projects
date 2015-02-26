class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :email
      t.string :key
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
