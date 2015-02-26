class AddReferenceValues < ActiveRecord::Migration
  def change
    create_table :reference_values do |t|
      t.string :type
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
