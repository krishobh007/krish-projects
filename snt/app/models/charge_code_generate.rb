class ChargeCodeGenerate < ActiveRecord::Base
  attr_accessible :charge_code_id, :generate_charge_code_id, :is_inclusive

  validates :charge_code_id, :generate_charge_code_id, presence: true
  validates :charge_code_id, uniqueness: { scope: :generate_charge_code_id }
  has_many :tax_calculation_rules

  belongs_to :charge_code
  belongs_to :generate_charge_code, class_name: 'ChargeCode'

  scope :tax, ->(hotel) { where('generate_charge_code_id IN (?)', hotel.charge_codes.tax.pluck(:id)) }
  scope :fees, ->(hotel) { where('generate_charge_code_id IN (?)', hotel.charge_codes.fees.pluck(:id)) }

  def tax_calculation_rule_charge_codes
  	calculation_rule_charge_codes = []
    self.tax_calculation_rules.each do |rule| #pluck(:linked_charge_code_generate_id)
      linked_charge_code_generate = ChargeCodeGenerate.find(rule.linked_charge_code_generate_id)
      linked_charge_code  = ChargeCode.find(linked_charge_code_generate.generate_charge_code_id)
      calculation_rule_charge_codes << linked_charge_code
    end
    calculation_rule_charge_codes
  end
end
