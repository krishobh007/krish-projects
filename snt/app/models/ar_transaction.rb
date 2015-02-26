class ArTransaction < ActiveRecord::Base
  attr_accessible :hotel_id, :bill_id, :account_id, :reservation_id, :credit, :debit, :paid_on, :date
  
  #Associations
  belongs_to :hotel
  belongs_to :bill
  belongs_to :account
  belongs_to :reservation

  scope :paid, -> { where('paid_on IS NOT NULL AND bill_id IS NOT NULL AND debit IS NOT NULL AND ar_transactions.reservation_id IS NOT NULL') }
  scope :unpaid, -> { where('paid_on IS NULL AND bill_id IS NOT NULL AND debit IS NOT NULL AND ar_transactions.reservation_id IS NOT NULL') }
  scope :credits, -> { where('bill_id IS NULL AND credit IS NOT NULL') }
  scope :debits, -> { where('bill_id IS NOT NULL AND debit IS NOT NULL') }
  scope :checked_out_after, ->(from_date) { where('date >= ?', from_date) }
  scope :checked_out_before, ->(to_date) { where('date <= ?', to_date) }
  scope :search_by_guest_name_or_room_or_confirm_no, ->(query) { where('guest_details.first_name like ? OR guest_details.last_name LIKE ? OR reservations.confirm_no LIKE ? OR rooms.room_no LIKE ?', "%#{query.upcase}%", "%#{query.upcase}%", "%#{query.upcase}%", "%#{query.upcase}%") }
  scope :search_by_room_no, ->(query) { where('rooms.room_no LIKE ?', "%#{query.upcase}%") }

  def pay
    hotel = self.hotel
    ar_transactions = hotel.ar_transactions.where(account_id: account_id)
    available_credits = ar_transactions.credits.sum(:credit)
    if debit.andand.round(2) <= available_credits.andand.round(2) && !paid_on
      self.paid_on = hotel.active_business_date
      self.save
      hotel.ar_transactions.create({
        account_id: self.account_id,
        credit: -(self.debit) 
        })
      true
    else
      false
    end
  end

  def open
    hotel = self.hotel
    if self.paid_on
      self.paid_on = nil
      self.save
      hotel.ar_transactions.create({
        account_id: self.account_id,
        credit: self.debit 
        })
      true
    else
      false
    end
  end
end