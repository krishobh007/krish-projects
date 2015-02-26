class RemoveColumnsFromReservations < ActiveRecord::Migration
  def up
    remove_column :reservations, :company
    remove_column :reservations, :membership_type
    remove_column :reservations, :membership_no
    remove_column :reservations, :group_name
    remove_column :reservations, :email
    remove_column :reservations, :room_no
    remove_column :reservations, :room_status
    remove_column :reservations, :full_name
    remove_column :reservations, :adults
    remove_column :reservations, :children
    remove_column :reservations, :credit_card_exp_date
    remove_column :reservations, :credit_card_no
    remove_column :reservations, :credit_card_type
    remove_column :reservations, :accompanying_guests
    remove_column :reservations, :accompanying
    remove_column :reservations, :comments
    remove_column :reservations, :external_conf_no
    remove_column :reservations, :external_seg_no
    remove_column :reservations, :external_seq_no
    remove_column :reservations, :currency_code
    remove_column :reservations, :guarantee_type_desc
    remove_column :reservations, :language
    remove_column :reservations, :market_segment_desc
    remove_column :reservations, :middle_name
    remove_column :reservations, :membership_level
    remove_column :reservations, :nationality
    remove_column :reservations, :passport_no
    remove_column :reservations, :payment_amount
    remove_column :reservations, :payment_method
    remove_column :reservations, :payment_method_desc
    remove_column :reservations, :is_psuedo_room_type
    remove_column :reservations, :rate_amount
    remove_column :reservations, :rate_code
    remove_column :reservations, :rate_code_tax_incl
    remove_column :reservations, :room_features
    remove_column :reservations, :room_type
    remove_column :reservations, :source_code_desc
    remove_column :reservations, :suite_room_no
    remove_column :reservations, :special_requests
    remove_column :reservations, :title
    remove_column :reservations, :title_desc
    remove_column :reservations, :travel_agent_name
  end

  def down
    add_column :reservations, :company, :string
    add_column :reservations, :membership_type, :integer
    add_column :reservations, :membership_no, :integer
    add_column :reservations, :group_name, :string
    add_column :reservations, :block_code, :string
    add_column :reservations, :email, :string
    add_column :reservations, :room_no, :string
    add_column :reservations, :room_status, :string
    add_column :reservations, :full_name, :string
    add_column :reservations, :adults, :integer
    add_column :reservations, :children, :integer
    add_column :reservations, :credit_card_exp_date, :date
    add_column :reservations, :credit_card_no, :string
    add_column :reservations, :credit_card_type, :string
    add_column :reservations, :accompanying_guests, :integer
    add_column :reservations, :accompanying, :integer
    add_column :reservations, :comments, :string
    add_column :reservations, :external_conf_no, :string
    add_column :reservations, :external_seg_no, :string
    add_column :reservations, :external_seq_no, :string
    add_column :reservations, :currency_code, :string
    add_column :reservations, :guarantee_type_desc, :string
    add_column :reservations, :language, :string
    add_column :reservations, :market_segment_desc, :string
    add_column :reservations, :middle_name, :string
    add_column :reservations, :membership_level, :string
    add_column :reservations, :nationality, :string
    add_column :reservations, :passport_no, :string
    add_column :reservations, :payment_amount, :string
    add_column :reservations, :payment_method, :string
    add_column :reservations, :payment_method_desc, :string
    add_column :reservations, :is_psuedo_room_type, :integer
    add_column :reservations, :rate_amount, :decimal, precision: 10, scale: 2
    add_column :reservations, :rate_code, :string
    add_column :reservations, :rate_code_tax_incl, :string
    add_column :reservations, :room_features, :string
    add_column :reservations, :room_type, :string
    add_column :reservations, :source_code_desc, :string
    add_column :reservations, :suite_room_no, :string
    add_column :reservations, :special_requests, :string
    add_column :reservations, :title, :string
    add_column :reservations, :title_desc, :string
    add_column :reservations, :travel_agent_name, :string
  end
end
