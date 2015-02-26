class CreatePreReservations < ActiveRecord::Migration
  def up
    create_table 'pre_reservations' do |t|
      t.references :room,       null: false
      t.references :user,       null: false
      t.column :from_time,      :datetime, null: false
      t.column :to_time,        :datetime, null: false
      t.column :confirm_no,     :string, null: false
    end
  end

  def down
    drop_table 'pre_reservations'
  end
end
