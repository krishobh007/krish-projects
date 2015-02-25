class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_id
      t.string :client_email

      t.timestamps
    end
  end
end
