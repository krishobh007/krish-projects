class AddSequenceNumberToCreditCardTransaction < ActiveRecord::Migration
  def change
    add_column :credit_card_transactions, :sequence_number, :integer
  end
end
