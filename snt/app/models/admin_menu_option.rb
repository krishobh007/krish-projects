class AdminMenuOption < ActiveRecord::Base
  attr_accessible :name, :is_group, :icon_class, :action_path, :parent_id, :admin_menu_id, :action_state, :require_standalone_pms, :require_external_pms
  translates :name

  belongs_to :admin_menu

  validates :name, :action_path, :admin_menu_id, :action_state, presence: true
  validates :name, uniqueness: { scope: [:admin_menu_id], case_sensitive: false }

  has_and_belongs_to_many :users, join_table: "user_admin_bookmarks"

end
