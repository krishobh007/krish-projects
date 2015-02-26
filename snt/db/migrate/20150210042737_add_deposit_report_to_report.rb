class AddDepositReportToReport < ActiveRecord::Migration
  def change
  	 deposit_report = Report.new(:title => "Deposit Report", :description => "Deposit due / paid by date" , :method => "deposit_report")
  	 deposit_report.save
  end
end
