class CreateHotelsEarlyCheckinGroups < ActiveRecord::Migration
  def up
  	create_table "hotels_early_checkin_groups" do |t|
  	  t.integer :hotel_id
  	  t.integer :group_id
  	end
  end
end
