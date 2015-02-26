class AddStreet3ToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :street3, :string
  end
end
