module SeedChargeCodeGenerate
  def create_charge_code_generate
    charge_codes = ChargeCode.all
    ChargeCodeGenerate.create(charge_code_id: charge_codes[0].id , generate_charge_code_id: charge_codes[1].id)
    ChargeCodeGenerate.create(charge_code_id: charge_codes[0].id , generate_charge_code_id: charge_codes[2].id)
  end
end
