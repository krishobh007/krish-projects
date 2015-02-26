class CreateRefReportFilters < ActiveRecord::Migration
  def change
    create_table :ref_report_filters do |t|
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
