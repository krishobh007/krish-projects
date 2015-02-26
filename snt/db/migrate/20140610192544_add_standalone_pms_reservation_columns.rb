class AddStandalonePmsReservationColumns < ActiveRecord::Migration
  def change
    add_column :reservations, :reservation_type_id, :integer
    add_column :reservations, :source_id, :integer
    add_column :reservations, :market_segment_id, :integer
    add_column :reservations, :booking_origin_id, :integer

    remove_column :reservation_daily_instances, :company_id
    remove_column :reservation_daily_instances, :travel_agent_id
  end
end
