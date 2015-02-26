class CreatePreCheckinExcludedRateCodes < ActiveRecord::Migration
  def change
  	create_table :pre_checkin_excluded_rate_codes do |t|
      t.integer :hotel_id, null: false
      t.integer :rate_id
      t.timestamps
    end
  end
end
