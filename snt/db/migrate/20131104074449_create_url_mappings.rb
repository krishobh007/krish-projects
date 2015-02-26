class CreateUrlMappings < ActiveRecord::Migration
  def change
    create_table :url_mappings do |t|
      t.string :url
      t.references :hotel_chain
      t.references :hotel
      t.references :created_by
      t.references :updated_by
      t.timestamps
    end
  end
end
