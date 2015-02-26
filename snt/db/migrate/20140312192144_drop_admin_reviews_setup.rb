class DropAdminReviewsSetup < ActiveRecord::Migration
  def change
    drop_table :admin_reviews_setups
  end
end
