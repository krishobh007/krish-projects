class CreateHotelRefReviewCategoriesTable < ActiveRecord::Migration
  def up
    create_table :hotel_review_categories, id: false do |t|
      t.references :hotel
      t.references :ref_review_category
    end
    add_index :hotel_review_categories, :hotel_id
  end

  def down
    drop_table :hotel_review_categories
  end
end
