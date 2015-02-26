class CreateAdminReviewsSetups < ActiveRecord::Migration
  def change
    create_table :admin_reviews_setups do |t|
      t.boolean :is_guest_reviews_on
      t.integer :reviews_per_page
      t.float :rating_for_auto_publish
      t.integer :hotel_id

      t.timestamps
    end
  end
end
