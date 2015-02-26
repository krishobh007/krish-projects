class AddPromotionCodeRates < ActiveRecord::Migration
  def change
    add_column :rates, :promotion_code, :string
  end
end
