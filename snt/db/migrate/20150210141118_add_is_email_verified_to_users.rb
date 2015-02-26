class AddIsEmailVerifiedToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_email_verified, :boolean, :default=>0
  end
end
