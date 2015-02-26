class CreateKeyEncoders < ActiveRecord::Migration
  def change
    create_table :key_encoders do |t|
      t.references :hotel, null: false
      t.string :description, null: false
      t.string :location
      t.string :encoder_id, null: false
      t.boolean :enabled, null: false, default: true
      t.timestamps
      t.userstamps
    end
  end
end
