class AddFieldsToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :based_on_type, :string
    add_column :contracts, :based_on_value, :integer
  end
end
