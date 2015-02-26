class Review < ActiveRecord::Base
  attr_accessible :description, :title , :reservation_id, :creator_id, :updater_id
  belongs_to :reservation
  belongs_to :user, foreign_key: 'updater_id'
  has_many :review_ratings, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, :reservation_id, :creator_id, :updater_id, presence: true

  def hotel
    reservation.hotel
  end
end
