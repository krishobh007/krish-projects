class ChargeRouting < ActiveRecord::Base
  attr_accessible :bill_id, :to_bill_id, :charge_code_id, :owner_id, :owner_name, :room_id, :external_routing_instructions, :billing_group_id

  belongs_to :bill
  belongs_to :to_bill, class_name: 'Bill'
  belongs_to :guest, foreign_key: :owner_id, class_name: 'GuestDetail'

  belongs_to :room
  belongs_to :charge_code
  belongs_to :billing_group
  
  validates :bill_id, presence: true
end
