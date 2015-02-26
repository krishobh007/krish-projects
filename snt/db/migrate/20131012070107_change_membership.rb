class ChangeMembership < ActiveRecord::Migration
  def change
    add_column :user_memberships, :membership_start_date, :date
    add_column :user_memberships, :external_id, :integer
  end
end
