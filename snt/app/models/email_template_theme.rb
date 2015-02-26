class EmailTemplateTheme < ActiveRecord::Base
  attr_accessible :is_system_specific, :name

  validates :name, presence: true, uniqueness: true

  has_many :email_templates

end
