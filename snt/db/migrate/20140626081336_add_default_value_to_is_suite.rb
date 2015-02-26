class AddDefaultValueToIsSuite < ActiveRecord::Migration
  def change
    execute('update room_types set  is_suite= false where is_suite is null')
    change_column :room_types, :is_suite, :boolean, default: false, null: false
  end
end
