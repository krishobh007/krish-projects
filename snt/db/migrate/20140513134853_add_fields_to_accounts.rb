class AddFieldsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :account_first_name, :string
    add_column :accounts, :account_last_name, :string
    add_column :accounts, :contact_first_name, :string
    add_column :accounts, :contact_last_name, :string
    add_column :accounts, :contact_job_title, :string
    add_column :accounts, :contact_email, :string
    add_column :accounts, :corporate_id, :string
    add_column :accounts, :contact_phone, :string
    add_column :accounts, :ar_number, :integer
    add_column :accounts, :web_page, :string
    add_column :accounts, :billing_information, :string
    remove_column :accounts, :account_name
    add_column :accounts, :accounts_receivable_number, :integer
  end
end
