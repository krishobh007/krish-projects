class RemoveDefaultDepositReport < ActiveRecord::Migration

  def change
    # 20150210042737_ this migration generate issue in loading report.
    # Quick Fix by removing default loaded deposit report and seed data will create
    # new entry.
    title = Report.find_by_title('Deposit Report')
    title.filters = []
    title.sortable_fields = []
    title.destroy
  end

end
