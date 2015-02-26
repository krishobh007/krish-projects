class RemoveRateTypeDescription < ActiveRecord::Migration
  def change
    remove_column :rate_types, :description
  end
end
