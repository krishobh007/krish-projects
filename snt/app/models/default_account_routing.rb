class DefaultAccountRouting < ActiveRecord::Base
   attr_accessible :account_id, :charge_code_id, :billing_group_id, :hotel_id
   belongs_to :account
   belongs_to :hotel

   scope :for_hotel, proc { |hotel| where("default_account_routings.hotel_id = ? ", hotel.id) }  

end
