class ChangeRestrictionTypeNames < ActiveRecord::Migration
  def change
    execute('update ref_restriction_types set description = "Deposit Requests" where value = "DEPOSIT_REQUESTED"')
  end
end
