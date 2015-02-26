class CreateReservationsTable < ActiveRecord::Migration
  def up
    create_table :reservations do |t|
      t.string :last_name
      t.string :first_name
      t.integer :confirm_no
      t.string :company
      t.integer :membership_type
      t.integer :membership_no
      t.date :arrival_date
      t.date :dep_date
      t.string :res_group_name
      t.integer :res_group_id
      t.string :block_code
      t.string :status
      t.string :email
      t.integer :room_no
      t.references :hotel
      t.references :user
      t.timestamps
    end

    add_index :reservations, :hotel_id
    add_index :reservations, :user_id
   end

  def down
    drop_table :reservations
  end
end
