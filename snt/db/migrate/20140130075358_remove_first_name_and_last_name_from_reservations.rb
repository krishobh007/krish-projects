class RemoveFirstNameAndLastNameFromReservations < ActiveRecord::Migration
  def up
    remove_column :reservations, :first_name
    remove_column :reservations, :last_name
  end

  def down
    add_column :reservations, :last_name, :string
    add_column :reservations, :first_name, :string
  end
end
