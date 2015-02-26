class UpdateSearchIndexes < ActiveRecord::Migration
  def up
    remove_index :users, :first_name
    remove_index :users, :last_name
    remove_index :groups, :name

    remove_index :reservations, :hotel_id
    remove_index :reservations, :confirm_no
    remove_index :reservations, :arrival_date
    remove_index :reservations, :dep_date

    remove_index :reservation_daily_instances, :reservation_date
    remove_index :reservation_daily_instances, :reservation_id
    remove_index :reservation_daily_instances, :group_id
    remove_index :reservation_daily_instances, :room_id
    remove_index :reservation_daily_instances, :room_type_id
    remove_index :reservation_daily_instances, :rate_id

    execute('DELETE r1 FROM reservations r1, reservations r2 WHERE r1.id > r2.id AND r1.confirm_no = r2.confirm_no AND r1.hotel_id = r2.hotel_id')
    execute('DELETE r1 FROM reservation_daily_instances r1, reservation_daily_instances r2 WHERE r1.id > r2.id AND ' \
            'r1.reservation_id = r2.reservation_id AND r1.reservation_date = r2.reservation_date;')

    add_index :reservations, [:hotel_id, :status_id, :arrival_date]
    add_index :reservations, [:hotel_id, :status_id, :dep_date]
    add_index :reservations, [:hotel_id, :confirm_no], unique: true

    add_index :reservation_daily_instances, [:reservation_id, :reservation_date], name: 'index_res_daily_instances_on_res_id_and_res_date',
                                                                                  unique: true
  end

  def down
    remove_index :reservation_daily_instances, name: 'index_res_daily_instances_on_res_id_and_res_date'

    remove_index :reservations, [:hotel_id, :confirm_no]
    remove_index :reservations, [:hotel_id, :status_id, :dep_date]
    remove_index :reservations, [:hotel_id, :status_id, :arrival_date]

    add_index :users, :first_name
    add_index :users, :last_name
    add_index :groups, :name

    add_index :reservations, :hotel_id
    add_index :reservations, :confirm_no
    add_index :reservations, :arrival_date
    add_index :reservations, :dep_date

    add_index :reservation_daily_instances, :reservation_date
    add_index :reservation_daily_instances, :reservation_id
    add_index :reservation_daily_instances, :group_id
    add_index :reservation_daily_instances, :room_id
    add_index :reservation_daily_instances, :room_type_id
    add_index :reservation_daily_instances, :rate_id
  end
end
