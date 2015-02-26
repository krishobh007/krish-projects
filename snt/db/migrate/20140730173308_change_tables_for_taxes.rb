class ChangeTablesForTaxes < ActiveRecord::Migration
  def change
    add_column :charge_codes, :amount, :decimal, precision: 10, scale: 2
    add_column :charge_codes, :post_type_id, :integer
    add_column :charge_codes, :amount_type_id, :integer
    add_column :charge_codes, :amount_symbol, :string

    # The charge_code_generate record can be inclusive or exclusive
    add_column :charge_code_generates, :is_inclusive, :boolean, default: false

    # One charge_code_generate record can be linked to more than one charge_code_generates depending on 
    # which of them are selected to add for tax calculation 
    create_table :tax_calculation_rules do |t|
      t.integer :charge_code_generate_id
      t.integer :linked_charge_code_generate_id
    end
  end
end
