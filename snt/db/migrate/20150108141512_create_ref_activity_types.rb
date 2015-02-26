class CreateRefActivityTypes < ActiveRecord::Migration
  def change
    create_table :ref_activity_types do |t|
    t.string :value, null: false
    t.string :description
    end
  end
end
