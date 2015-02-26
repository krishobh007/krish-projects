class AddArticleIdToFinancialTxn < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :article_id, :integer , references: :articles
  end
end
