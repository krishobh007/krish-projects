class CreateRefPostingRythms < ActiveRecord::Migration
  def change
    create_table :ref_posting_rythms do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
   end
end
