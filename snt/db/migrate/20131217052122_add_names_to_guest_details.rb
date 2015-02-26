class AddNamesToGuestDetails < ActiveRecord::Migration
  def change
    add_column :guest_details, :first_name, :string
    add_column :guest_details, :last_name, :string
  end
end
