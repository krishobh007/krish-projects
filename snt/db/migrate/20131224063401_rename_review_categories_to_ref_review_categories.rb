class RenameReviewCategoriesToRefReviewCategories < ActiveRecord::Migration
  def change
    rename_table :review_categories, :ref_review_categories
    rename_column :ref_review_categories, :name, :value
    add_column :ref_review_categories, :description, :string
    end
end
