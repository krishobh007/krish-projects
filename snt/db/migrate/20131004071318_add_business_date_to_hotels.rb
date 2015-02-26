class AddBusinessDateToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :business_date, :date, null: false
  end
end
