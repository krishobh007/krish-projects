class CreateDefaultAccountRoutings < ActiveRecord::Migration
  def change
    create_table :default_account_routings do |t|
      t.integer :account_id
      t.integer :charge_code_id
      t.integer :billing_group_id
      
      t.timestamps
    end
  end
end
