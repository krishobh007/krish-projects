class AddIsActiveToGuestWebToken < ActiveRecord::Migration
  def change
    add_column :guest_web_tokens, :is_active, :boolean, default: true
  end
end
