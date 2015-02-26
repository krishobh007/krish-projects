class RemoveEmailFromGuestDetails < ActiveRecord::Migration
  def up
    remove_column :guest_details, :email
  end

  def down
    add_column :guest_details, :email, :string
  end
end
