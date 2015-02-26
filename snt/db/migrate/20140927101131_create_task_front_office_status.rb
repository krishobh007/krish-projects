class CreateTaskFrontOfficeStatus < ActiveRecord::Migration
  def up
    create_table :front_office_statuses_tasks do |t|
      t.references :task, index: true
      t.references :front_office_status, index: true
      t.timestamps
    end
  end

  def down
  end
end
