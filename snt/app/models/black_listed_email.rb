class BlackListedEmail < ActiveRecord::Base
  attr_accessible :email, :hotel_id
  belongs_to :hotel
  
  
  validates_uniqueness_of :email, scope: [:hotel_id]
  validate :email_should_be_regex
  
  def email_should_be_regex
    begin
      Regexp.new(email)
    rescue RegexpError => ex
      errors.add(:email, "should be in valid regex format. #{ex.message}")
    end
  end
end