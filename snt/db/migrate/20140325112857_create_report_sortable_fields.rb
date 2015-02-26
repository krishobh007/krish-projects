class CreateReportSortableFields < ActiveRecord::Migration
  def change
    create_table :report_sortable_fields do |t|
      t.references :report
      t.integer :sortable_field_id
    end
  end
end
