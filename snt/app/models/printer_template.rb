class PrinterTemplate < ActiveRecord::Base
  attr_accessible :template, :hotel_id, :template_type
  belongs_to :hotel
  validates_uniqueness_of :template_type, :scope=>[:hotel_id]
  scope :checkin_bill_templates, -> { where(template_type: Setting.printer_template_types[:checkin]) }
  scope :checkout_bill_templates, -> { where(template_type: Setting.printer_template_types[:checkout]) }

  def self.checkin_bill_template
    checkin_bill_templates.first
  end

  def self.checkout_bill_template
  	checkout_bill_templates.first
  end

end
