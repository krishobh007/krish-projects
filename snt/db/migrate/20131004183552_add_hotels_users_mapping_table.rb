class AddHotelsUsersMappingTable < ActiveRecord::Migration
  def change
    create_table :hotels_users, id: false do |t|
      t.belongs_to :hotel
      t.belongs_to :user
    end

    rename_column :users, :emp_hotel_id, :default_hotel_id
  end
end
