class AddEmailToGuestDetails < ActiveRecord::Migration
  def change
    add_column :guest_details, :email, :string
  end
end
