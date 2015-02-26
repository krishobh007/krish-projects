class UserAdminBookmark < ActiveRecord::Base
  attr_accessible :user_id, :admin_menu_option_id
  validates :user_id, :admin_menu_option_id, presence: true

  belongs_to :user
  belongs_to :admin_menu_option

  validates :admin_menu_option_id, uniqueness: { scope: [:user_id] }
  validates :user_id, presence: true
end
