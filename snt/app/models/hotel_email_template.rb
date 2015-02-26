class HotelEmailTemplate < ActiveRecord::Base
  attr_accessible :hotel_id, :email_template_id

  belongs_to :email_template
  belongs_to :hotel

  validates :hotel_id, :email_template_id, presence: true

end
