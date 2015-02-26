class CreateExternalMappings < ActiveRecord::Migration
  def change
    create_table :external_mappings do |t|
      t.string :external_system, limit: 80 # For eg: Like OWS
      t.string :external_value, limit: 80 # For Eg: For Home in OPERA it represent as 'H'
      t.string :value, limit: 80 # Internal SNT value
      t.references :hotel
      t.references :hotel_chain
      t.string :mapping_type, limit: 55 # It will Phone Type, Address Type etc
      t.boolean :is_inactive, default: false # Whether this value is active or not active

      t.timestamps
    end
  end
end
