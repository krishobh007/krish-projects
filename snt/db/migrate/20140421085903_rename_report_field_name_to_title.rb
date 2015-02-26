class RenameReportFieldNameToTitle < ActiveRecord::Migration
  def up
    rename_column :reports, :name, :title
  end

  def down
    rename_column :reports, :title, :name
  end
end
