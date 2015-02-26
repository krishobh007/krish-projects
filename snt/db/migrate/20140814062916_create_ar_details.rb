class CreateArDetails < ActiveRecord::Migration
  def change
    create_table :ar_details do |t|
      t.integer :account_id
      t.string :contact_first_name
      t.string :ar_number
      t.string :contact_last_name
      t.string :job_title
      t.boolean :is_use_main_contact
      t.boolean :is_use_main_address
      t.timestamps
    end
  end
end
