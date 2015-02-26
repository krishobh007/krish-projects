class CreateRefReportSortableFields < ActiveRecord::Migration
  def change
    create_table :ref_report_sortable_fields do |t|
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
