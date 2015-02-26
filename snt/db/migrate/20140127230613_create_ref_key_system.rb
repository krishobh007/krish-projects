class CreateRefKeySystem < ActiveRecord::Migration
  def change
    create_table :ref_key_systems do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
