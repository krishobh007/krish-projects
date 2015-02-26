class CreateRefDashboards < ActiveRecord::Migration
  def change
    create_table :ref_dashboards do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
