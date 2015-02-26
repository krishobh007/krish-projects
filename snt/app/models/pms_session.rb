class PmsSession < ActiveRecord::Base
  attr_accessible :session_id, :user_id
  self.table_name = 'sessions'

  belongs_to :user

  validates :session_id, :user_id, presence: true

  def as_json(opts = {})
    json = super(opts)
    Hash[*json.map { |k, v| [k, v.to_s || ''] }.flatten]
  end
end
