class GuestWebToken < ActiveRecord::Base
  attr_accessible :access_token, :guest_detail_id, :is_active,:reservation_id,:email_type

  belongs_to :reservation, :class_name => 'Reservation', :foreign_key => "reservation_id"
  belongs_to :guest_detail, :class_name => 'GuestDetail', :foreign_key => "guest_detail_id"

end
