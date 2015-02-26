class AddIdToHotelsPaymentTypes < ActiveRecord::Migration
  def change
    add_column :hotels_payment_types, :id, :primary_key
    add_column :hotels_payment_types, :is_cc, :boolean, :default => false
    add_column :hotels_payment_types, :is_offline, :boolean, :default => false
    add_column :hotels_payment_types, :is_rover_only, :boolean, :default => false
    add_column :hotels_payment_types, :is_web_only, :boolean, :default => false
    add_column :hotels_payment_types, :active, :boolean, :default => true
  
  end
end
