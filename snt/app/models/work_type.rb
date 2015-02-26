class WorkType < ActiveRecord::Base
  before_destroy :is_system_defined?, :has_future_work_sheets?
  before_update :is_system_defined?
  
  attr_accessible :id, :name, :hotel_id, :is_active
  belongs_to :hotel
  has_many :tasks
  has_many :work_sheets
  
  validates :name, presence: true
  
  def is_system_defined?
    errors.add(:is_system, "defined") if is_system
    errors.blank?
  end
  
  def has_future_work_sheets?
    errors.add(:work_type, "has future work sheets") if work_sheets.where('date >= date(?)', Time.now).count > 0
    errors.blank?
  end
end