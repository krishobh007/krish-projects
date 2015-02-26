class TaxCalculationRule < ActiveRecord::Base
  attr_accessible :charge_code_generate_id, :linked_charge_code_generate_id
  belongs_to :charge_code_generate
end