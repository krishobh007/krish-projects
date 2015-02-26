class ActionDetail < ActiveRecord::Base
  attr_accessible :action_id, :action, :key, :old_value, :new_value

  belongs_to :action, inverse_of: :details

  validates :action, :key, presence: true
  validates :key, uniqueness: { scope: :action_id, case_sensitive: false }
end
