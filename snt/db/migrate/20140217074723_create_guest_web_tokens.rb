class CreateGuestWebTokens < ActiveRecord::Migration
  def change
    create_table :guest_web_tokens do |t|
      t.integer :guest_detail_id,  references: :guest_detail
      t.string :access_token
      t.timestamps
    end
  end
end
