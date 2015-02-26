class ConvertMembershipNumber < ActiveRecord::Migration
  def change
    change_column :user_memberships, :membership_card_number, :string
  end
end
