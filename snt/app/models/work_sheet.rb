class WorkSheet < ActiveRecord::Base
  attr_accessible :id, :user_id, :work_type_id, :shift_id, :date

  before_create :add_sheet_number
  
  belongs_to :user
  belongs_to :work_type
  belongs_to :shift
  
  has_many :work_assignments

  validates :date, presence: true
  validates :work_type_id, presence: true
  
  validates_uniqueness_of :date, :message => "has a worksheet for the task and user",
         :scope => [:user_id, :work_type_id], unless: Proc.new { |sheet| sheet.user_id.blank? }
  
  def add_sheet_number
    last_sheet_number = WorkSheet.joins(work_type: :hotel).where(:date => self.date).count
    self.sheet_number = last_sheet_number + 1
  end
end