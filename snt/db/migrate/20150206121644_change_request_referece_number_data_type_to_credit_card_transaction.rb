class ChangeRequestRefereceNumberDataTypeToCreditCardTransaction < ActiveRecord::Migration
  def up
    change_column :credit_card_transactions, :req_reference_no, :string
  end

  def down
    change_column :credit_card_transactions, :req_reference_no, :integer
  end
end
