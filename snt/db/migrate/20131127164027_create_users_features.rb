class CreateUsersFeatures < ActiveRecord::Migration
  def change
    create_table :users_features, id: false do |t|
      t.references :user, null: false, index: true
      t.references :feature, null: false, index: true
    end
  end
end
