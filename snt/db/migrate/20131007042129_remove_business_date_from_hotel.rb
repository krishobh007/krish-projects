class RemoveBusinessDateFromHotel < ActiveRecord::Migration
  def up
    remove_column :hotels, :business_date
  end

  def down
    add_column :hotels, :business_date, :date
  end
end
