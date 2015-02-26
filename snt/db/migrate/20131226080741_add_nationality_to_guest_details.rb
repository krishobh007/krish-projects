class AddNationalityToGuestDetails < ActiveRecord::Migration
  def change
    add_column :guest_details, :nationality, :string
  end
end
