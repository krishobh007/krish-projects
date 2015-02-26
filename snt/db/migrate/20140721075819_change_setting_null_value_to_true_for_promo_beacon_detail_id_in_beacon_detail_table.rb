class ChangeSettingNullValueToTrueForPromoBeaconDetailIdInBeaconDetailTable < ActiveRecord::Migration
  def change
    change_column :beacon_details, :promo_detail_id, :integer, null: true
  end
end
