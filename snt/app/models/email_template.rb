class EmailTemplate < ActiveRecord::Base
  attr_accessible :body, :hotel_id, :subject, :title, :signature, :email_template_theme_id

  validates :body, :subject, :title, presence: true
  validates :title,  uniqueness: { scope: :email_template_theme_id, case_sensitive: false }
  has_many :hotels, through: :hotel_email_templates
  has_many :hotel_email_templates

end
