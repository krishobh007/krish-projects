class CreateGuestFeatures < ActiveRecord::Migration
  def change
    create_table :guest_features do |t|
      t.references :guest_detail, null: false, index: true
      t.references :feature, null: false, index: true
    end
  end
end
