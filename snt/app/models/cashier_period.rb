class CashierPeriod < ActiveRecord::Base
  attr_accessible :starts_at, :ends_at, :user_id, :status, :checks_submitted,
                  :cash_submitted, :closing_balance_check, :closing_balance_cash

  belongs_to :user
  belongs_to :updater, class_name: 'User', foreign_key: 'updater_id'
  has_many :financial_transactions
  # Method to open a cashier period
  def self.open(options)
  	cashier_period_attrs = {
      status: 'OPEN',
  	  starts_at: options[:starts_at]
    }
    user = User.find(options[:user_id])
    hotel = options[:hotel]
    cashier_period = user.cashier_periods.create(cashier_period_attrs)
    cashier_period
  end
  
  #Close a cashier period
  def self.close(options)
    cashier_period = CashierPeriod.find(options[:id])
    cashier_period.status = 'CLOSED'
    cashier_period.ends_at = options[:ends_at]
    cashier_period.cash_submitted = options[:cash_submitted]
    cashier_period.checks_submitted = options[:checks_submitted]
    cashier_period.closing_balance_check = options[:closing_balance_check]
    cashier_period.closing_balance_cash = options[:closing_balance_cash]
    cashier_period.updater_id = options[:updater_id]
    cashier_period.save
    cashier_period
  end

  def total_cash_received(hotel)
    # #Find all transactions made within the cashier period of type cash
    
    # start_time = self.starts_at.utc.strftime("%H:%M:%S")
    # end_time = self.ends_at ? self.ends_at.utc.strftime('%H:%M:%S') : Time.parse(hotel.current_time).strftime('%H:%M:%S')
    self.financial_transactions.cash(hotel).sum(:amount).to_f
  end

  def total_checks_received(hotel)
    # start_time = self.starts_at.utc.strftime("%H:%M:%S")
    # end_time = self.ends_at ? self.ends_at.utc.strftime('%H:%M:%S') : Time.parse(hotel.current_time).strftime('%H:%M:%S')
    # self.user.financial_transactions.where('TIME(time) >= ? AND TIME(time) <= ?',start_time,end_time).checks(hotel).sum(:amount).to_f
    self.financial_transactions.checks(hotel).sum(:amount).to_f
  end

  def prev_cashier_period
    self.user.cashier_periods.where('id < ?', self._id).last
  end

  def opening_balance_cash
    self.prev_cashier_period.andand.closing_balance_cash ? self.prev_cashier_period.closing_balance_cash : 0.0
  end

  def opening_balance_check
    self.prev_cashier_period.andand.closing_balance_check ? self.prev_cashier_period.closing_balance_check : 0.0
  end

end