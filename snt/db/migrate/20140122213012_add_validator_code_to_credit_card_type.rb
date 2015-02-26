class AddValidatorCodeToCreditCardType < ActiveRecord::Migration
  def change
    add_column :ref_credit_card_types, :validator_code, :string
  end
end
