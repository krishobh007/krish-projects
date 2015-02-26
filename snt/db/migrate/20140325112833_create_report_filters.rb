class CreateReportFilters < ActiveRecord::Migration
  def change
    create_table :report_filters do |t|
      t.references :report
      t.integer :filter_id
    end
  end
end
