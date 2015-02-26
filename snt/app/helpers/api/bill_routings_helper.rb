module Api
  module BillRoutingsHelper
    
    def is_already_used_in_reservation(item)
      return false if @reservation.nil?
      if item.is_a?(BillingGroup)
        return @reservation.bills.joins(:charge_routings).exists?('charge_routings.billing_group_id' => item.id)
      elsif item.is_a?(ChargeCode)
        return @reservation.bills.joins(:charge_routings).exists?('charge_routings.charge_code_id' => item.id)
      end
      return false
    end
  end
end