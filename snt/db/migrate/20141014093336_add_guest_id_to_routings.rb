class AddGuestIdToRoutings < ActiveRecord::Migration
  def change
  	add_column :charge_routings, :owner_id , :integer
  end
end
