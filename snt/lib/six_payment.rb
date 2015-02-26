module SixPayment
  def six_logger
    @six_logger ||= Logger.new("#{Rails.root}/log/six_payments.log")
  end
end

include SixPayment
