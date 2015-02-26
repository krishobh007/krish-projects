class AddAutoLogoutDelayToHotels < ActiveRecord::Migration
  def up
    add_column :hotels, :auto_logout_delay, :integer
  end

  def down
    remove_column :hotels, :auto_logout_delay
  end
end
