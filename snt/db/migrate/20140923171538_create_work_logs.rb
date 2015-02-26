class CreateWorkLogs < ActiveRecord::Migration
  def change
    create_table :work_logs do |t|
      t.references :room
      t.datetime :begin_time
      t.datetime :end_time
      t.timestamps
    end
  end
end
