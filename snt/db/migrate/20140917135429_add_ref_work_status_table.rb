class AddRefWorkStatusTable < ActiveRecord::Migration
  def change
    create_table :ref_work_statuses do |t|
      t.string :value
      t.string :description
      t.timestamps
    end
  end
end
