class AddNewColumnsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :full_name, :string
    add_column :reservations, :arrival_time, :time
    add_column :reservations, :adults, :integer
    add_column :reservations, :children, :integer
    add_column :reservations, :guest_id, :string
    add_column :reservations, :credit_card_exp_date, :date
    add_column :reservations, :credit_card_no, :string
    add_column :reservations, :credit_card_type, :string
    add_column :reservations, :cancellation_no, :string
    add_column :reservations, :cancel_date, :date
    add_column :reservations, :cancel_reason, :string
    add_column :reservations, :accompanying_guests, :integer
    add_column :reservations, :accompanying, :boolean
    add_column :reservations, :comments, :string
    add_column :reservations, :company_id, :string
    add_column :reservations, :no_room_move, :string
    add_column :reservations, :external_conf_no, :string
    add_column :reservations, :external_seg_no, :string
    add_column :reservations, :external_seq_no, :string
    add_column :reservations, :currency_code, :string
    add_column :reservations, :fixed_rate, :boolean
    add_column :reservations, :total_amount, :decimal, precision: 10, scale: 2
    add_column :reservations, :guarantee_type, :string
    add_column :reservations, :guarantee_type_desc, :string
    add_column :reservations, :language, :string
    add_column :reservations, :last_stay_room, :string
    add_column :reservations, :market_segment, :string
    add_column :reservations, :market_segment_desc, :string
    add_column :reservations, :middle_name, :string
    add_column :reservations, :membership_level, :string
    add_column :reservations, :nationality, :string
    add_column :reservations, :total_rooms, :string
    add_column :reservations, :party_code, :string
    add_column :reservations, :passport_no, :string
    add_column :reservations, :payment_amount, :decimal, precision: 10, scale: 2
    add_column :reservations, :payment_method, :string
    add_column :reservations, :payment_method_desc, :string
    add_column :reservations, :preferred_room_type, :string
    add_column :reservations, :print_rate, :boolean
    add_column :reservations, :is_psuedo_room_type, :boolean
    add_column :reservations, :rate_amount, :decimal, precision: 10, scale: 2
    add_column :reservations, :rate_code, :string
    add_column :reservations, :rate_code_tax_incl, :string
    add_column :reservations, :room_features, :string
    add_column :reservations, :room_type, :string
    add_column :reservations, :source_code, :string
    add_column :reservations, :source_code_desc, :string
    add_column :reservations, :suite_room_no, :string
    add_column :reservations, :special_requests, :string
    add_column :reservations, :title, :string
    add_column :reservations, :title_desc, :string
    add_column :reservations, :travel_agent_id, :string
    add_column :reservations, :travel_agent_name, :string
    add_column :reservations, :is_walkin, :boolean

    rename_column :reservations, :res_group_name, :group_name
    rename_column :reservations, :res_group_id, :group_id
  end
end
