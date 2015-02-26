class AddPromotionEmailToGuestDetail < ActiveRecord::Migration
  def change
    add_column :guest_details, :is_opted_promotion_email, :boolean, null: false, default: 0
  end
end
