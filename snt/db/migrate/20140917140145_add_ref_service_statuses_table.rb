class AddRefServiceStatusesTable < ActiveRecord::Migration
  def change
    create_table :ref_service_statuses do |t|
      t.string :value
      t.string :description
      t.timestamps
    end
  end
end
