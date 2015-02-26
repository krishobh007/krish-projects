class Policy < ActiveRecord::Base
  AMOUNT_TYPES = %w(amount percent day)

  attr_accessible :name, 
                  :description, 
                  :amount, 
                  :amount_type, 
                  :post_type_id, 
                  :apply_to_all_bookings, 
                  :advance_days, 
                  :advance_time, 
                  :hotel_id,
                  :policy_type_id, 
                  :policy_type, 
                  :charge_code_id,
                  :allow_deposit_edit

  belongs_to :hotel
  belongs_to :charge_code
  has_one :rate, foreign_key: 'cancellation_policy_id'
  
  has_enumerated :post_type, class_name: 'Ref::PostType'
  has_enumerated :policy_type, class_name: 'Ref::PolicyType'

  validates :hotel, :policy_type, :name, :amount, :amount_type, presence: true
  validates :amount_type, inclusion: { in: AMOUNT_TYPES }
  validates :post_type, presence: true, if: 'amount_type == "percent"'
  
  validates_uniqueness_of :apply_to_all_bookings, scope: [:hotel_id, :policy_type_id], if: Proc.new { |policy| policy.apply_to_all_bookings == true }
end
