class NumberUtility
  # Return amount in 2 decimal format
  def self.default_amount_format(amount, strip_decimals_if_zero = false)
    if amount != Setting.suppressed_rate
      # Set the amount to zero if null or blank
      amount = 0 unless amount.present?
      amount = amount.to_f.round(2)
      if strip_decimals_if_zero
        format('%g', amount).include?('.') ? format('%.2f', amount) : format('%g', amount)
      else
        format('%.2f', amount)
      end
    end
  end
end
