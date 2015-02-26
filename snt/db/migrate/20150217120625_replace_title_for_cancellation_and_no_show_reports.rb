class ReplaceTitleForCancellationAndNoShowReports < ActiveRecord::Migration
  def change
  	cancellation_and_no_show_report = Report.find_by_title('Cancelation & No Show')
  	if cancellation_and_no_show_report.present?
      cancellation_and_no_show_report.update_attributes(title: 'Cancellation & No Show')
    end
  end
end
