class HotelsPaymentType < ActiveRecord::Base
  attr_accessible :is_cc, :is_offline, :is_rover_only, :is_web_only, :hotel, :payment_type, :active, :is_display_reference
  
  belongs_to :hotel
  belongs_to :payment_type
  
  # validates :is_cc, :inclusion => {:in => [true, false]}
  # validates :is_rover_only, :inclusion => {:in => [true, false]}
  # validates :is_web_only, :inclusion => {:in => [true, false]}
end