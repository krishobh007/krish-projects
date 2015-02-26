module SeedDefaultManualCCEntry
  def create_disable_manual_credit_card_entry
    # For disabling manual operation to enter CC details(Possible Options - True/False)
    Setting.IS_ALLOW_MANUAL_CC = false if Setting.IS_ALLOW_MANUAL_CC.nil?
  end
end
