class AddColumnsToGuestWebToken < ActiveRecord::Migration
  def change
     add_column :guest_web_tokens,:reservation_id,:integer
     add_column :guest_web_tokens,:email_type,:string
  end
end
