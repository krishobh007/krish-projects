class AddAdditionalRateDetailsRates < ActiveRecord::Migration
  def change
     add_column :rates, :charge_code_id, :integer 
     add_column :rates, :market_segment_id, :integer
     add_column :rates, :source_id, :integer
     add_column :rates, :is_commission_on, :boolean, default: 0
     add_column :rates, :is_suppress_rate_on, :boolean, default: 0
     add_column :rates, :is_discount_allowed_on, :boolean, default: 0
     add_column :rates, :deposit_policy_id, :integer
     add_column :rates, :min_advanced_booking,  :integer 
     add_column :rates, :max_advanced_booking,  :integer     
     add_column :rates, :cancellation_policy_id,  :integer
     add_column :rates, :min_stay,  :integer
     add_column :rates, :max_stay,  :integer
     add_column :rates, :use_rate_levels,  :boolean, default: 0

  end
end
