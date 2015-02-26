class AddSubTitleToReports < ActiveRecord::Migration
  def change
    add_column :reports, :sub_title, :string
  end
end
