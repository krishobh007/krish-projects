class CreateGuestDetails < ActiveRecord::Migration
  def change
    create_table :guest_details do |t|
      t.integer :id
      t.references :user
      t.date :birthday
      t.string :gender
      t.boolean :is_vip
      t.string :title
      t.string :company
      t.string :works_at
      t.string :external_id
      t.string :passport_no
      t.date :passport_expiry
      t.string :image_url

      t.timestamps
    end
  end
end
