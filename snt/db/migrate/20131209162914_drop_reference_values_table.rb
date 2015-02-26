class DropReferenceValuesTable < ActiveRecord::Migration
  def up
    drop_table :reference_values
  end

  def down
    create_table :reference_values do |t|
      t.string :type
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
