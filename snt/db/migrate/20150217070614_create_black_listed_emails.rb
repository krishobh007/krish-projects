class CreateBlackListedEmails < ActiveRecord::Migration
  def up
    create_table :black_listed_emails do |t|
      t.string :email
      t.integer :hotel_id
      t.timestamps
    end
  end

end
