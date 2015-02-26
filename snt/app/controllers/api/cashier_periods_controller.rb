class Api::CashierPeriodsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  def index
    @cashiers = current_hotel.users.with_cashier_role
    @cashier_period_status = current_user.cashier_periods.where('DATE(starts_at) = ?', params[:date]).order('starts_at DESC').first.andand.status
    @history = current_user.cashier_periods
  end

  def show
    @cashier_period = current_user.cashier_periods.find(params[:id])
  end

  def reopen
    @cashier_period = CashierPeriod.find(params[:id])
    if @cashier_period.user.active_cashier_period
      render(json: [t(:active_cashier_period_exists)], status: :unprocessable_entity)
    else
      @cashier_period.status = 'OPEN'
      @cashier_period.ends_at = current_hotel.current_time
      @cashier_period.save
    end
    @cashier_period
  end

  def history
    user = current_hotel.users.find(params[:user_id])
    @last_cashier_period_id = user.last_cashier_period.andand.id
    @history = user.cashier_periods.where('GREATEST(IFNULL(DATE(starts_at), 0), IFNULL(DATE(ends_at), 0)) = ?', params[:date])
  end

  def close
    options = Hash.new
    options = {
      cash_submitted: params[:cash_submitted],
      checks_submitted: params[:check_submitted],
      ends_at: current_hotel.current_time,
      id: params[:id],
      closing_balance_cash: params[:closing_balance_cash],
      closing_balance_check: params[:closing_balance_check]
    }
    @cashier_period = CashierPeriod.close(options)
    @cashier_period
  end

end
