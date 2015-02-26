class FixCreatedByIdsOnUserPaymentTypes < ActiveRecord::Migration
  def change
    rename_column :user_payment_types, :created_by_id_id, :created_by_id
    rename_column :user_payment_types, :updated_by_id_id, :updated_by_id
  end
end
