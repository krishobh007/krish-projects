class AddColumnsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :original_arrival_date, :date
    add_column :reservations, :original_departure_date, :date
    add_column :reservations, :checkin_time, :time
    add_column :reservations, :checkout_time, :time
    add_column :reservations, :waitlist_reason, :string, limit: 2000
    add_column :reservations, :discount_type, :string, limit: 20
    add_column :reservations, :discount_amount, :decimal, precision: 10, scale: 2
    add_column :reservations, :discount_reason, :string, limit: 2000
    add_column :reservations, :is_posting_restricted, :boolean
    add_column :reservations, :is_video_checkout_disabled, :boolean
    add_column :reservations, :is_day_use, :boolean
  end
end
