class ChangePhoneColumnsToString < ActiveRecord::Migration
  def change
    change_column :hotels, :hotel_phone, :string
    change_column :users, :phone, :string
  end
end
