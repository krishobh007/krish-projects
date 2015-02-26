class RemoveIncludeTextFromFilterOptionsForDepositReports < ActiveRecord::Migration
  def change
  	Ref::ReportFilter.enumeration_model_updates_permitted = true
  	deposit_due = Ref::ReportFilter.find_by_value('DEPOSIT_DUE')
  	deposit_paid = Ref::ReportFilter.find_by_value('DEPOSIT_PAID')
  	deposit_past = Ref::ReportFilter.find_by_value('DEPOSIT_PAST')
  	deposit_due.update_attributes(description: "Deposit Due") if deposit_due
  	deposit_paid.update_attributes(description: "Deposit Paid") if deposit_paid
  	deposit_past.update_attributes(description: "Deposit Past") if deposit_past
  end
end
