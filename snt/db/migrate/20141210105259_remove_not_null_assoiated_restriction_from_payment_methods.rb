class RemoveNotNullAssoiatedRestrictionFromPaymentMethods < ActiveRecord::Migration
  def change
  	change_column :payment_methods, :associated_id, :integer, null: true
  	change_column :payment_methods, :associated_type, :string, null: true
  end
end
