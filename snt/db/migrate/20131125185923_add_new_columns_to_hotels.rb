class AddNewColumnsToHotels < ActiveRecord::Migration
  def change
    remove_column :hotels, :default_currency_code
    add_column :hotels, :default_currency_id, :integer
    add_column :hotels, :main_contact_first_name, :string
    add_column :hotels, :main_contact_last_name, :string
    add_column :hotels, :main_contact_email, :string
    add_column :hotels, :main_contact_phone, :string
  end
end
