class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.references :reviewable,    polymorphic: true

      t.references :reviewer,      polymorphic: true

      t.float :rating
      t.text :like
      t.text :dislike
      t.boolean :published

      #
      # Custom fields go here...
      #
      # t.string      :title
      # t.string      :intention
      # ...
      #

      t.timestamps
    end

    add_index :reviews, :reviewer_id
    add_index :reviews, :reviewer_type
    add_index :reviews, [:reviewer_id, :reviewer_type]
    add_index :reviews, [:reviewable_id, :reviewable_type]
  end

  def self.down
    drop_table :reviews
  end
end
