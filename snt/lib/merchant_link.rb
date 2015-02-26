module MerchantLink
  def mli_logger
    @mli_logger ||= Logger.new("#{Rails.root}/log/merchat_link.log")
  end
end

include MerchantLink