class Comment < ActiveRecord::Base
  attr_accessible :title, :comment, :author_name, :author_email, :user_id, :commentable_id, :commentable_type, :author_ip, :recipient_id

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :commentable_id, :commentable_type, :comment, presence: true

  scope :asc, -> { order('created_at ASC') }
  scope :desc, -> { order('created_at DESC') }

  def reservation
    user.guest_detail.current_reservation(hotel)
  end

  def hotel
    commentable.hotel
  end

  def as_json(options = {})
    opts = { only: [:comment, :author_name, :created_at] }.merge(options)
    result = super(opts)
    result = Hash[*result.map { |k, v| [k, v.to_s || ''] }.flatten]
    unless user.nil?
      # role = self.user.role_id
      # result[:type] = role == 1 ? "automated" : ((role == 5 || role == 4) ? "promotion" : "normal")
      result[:user] = user.as_json(except: [:api_key, :interests])
    end
    result[:created_at] = created_at.strftime('%Y-%m-%d %H:%M:%S')

    result
  end
end
