module Api::AccountsHelper
  # Get the current contracted rate for the account. If a from/to date is provided, get the first contracted rate between the date range.
  def current_contract(account)
    if params[:from_date].present? && params[:to_date].present?
      account.rates.overlapping(params[:from_date], params[:to_date]).first
    else
      account.rates.current(current_hotel.active_business_date).first
    end
  end
end
