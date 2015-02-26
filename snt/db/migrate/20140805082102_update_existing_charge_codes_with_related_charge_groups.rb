class UpdateExistingChargeCodesWithRelatedChargeGroups < ActiveRecord::Migration
  def change
    charge_codes = ChargeCode.all
    charge_group = ChargeGroup.first
    charge_codes.each do |charge_code|
      if !charge_code.charge_groups.present?
         charge_code.charge_groups << charge_group if charge_group
      end
    end
  end
end
