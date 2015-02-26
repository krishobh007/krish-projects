class AddRoomFeaturesTable < ActiveRecord::Migration
  def change
    create_table :room_features do |t|
      t.references :chain, index: true
      t.references :hotel, index: true
      t.string :room_feature, limit: 20, null: false
      t.string :short_desc, limit: 40, null: false
      t.string :description, limit: 2000
      t.references :created_by, null: false
      t.references :updated_by, null: false

      t.timestamps
    end
  end
end
