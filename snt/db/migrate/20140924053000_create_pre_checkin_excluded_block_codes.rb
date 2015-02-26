class CreatePreCheckinExcludedBlockCodes < ActiveRecord::Migration
  def change
  	create_table :pre_checkin_excluded_block_codes do |t|
      t.integer :hotel_id, null: false
      t.integer :group_id
      t.timestamps
    end
  end
end
