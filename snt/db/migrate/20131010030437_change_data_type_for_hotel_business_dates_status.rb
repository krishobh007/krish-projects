class ChangeDataTypeForHotelBusinessDatesStatus < ActiveRecord::Migration
  def change
    change_column 'hotel_business_dates', 'status', :string, default: 'OPEN', null: false
  end
end
