class AddSheetNumberToWorkSheet < ActiveRecord::Migration
  def change
    add_column :work_sheets, :sheet_number, :integer
  end
end
