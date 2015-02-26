class Payment < ActiveRecord::Base
  attr_accessible :reference_number, :hotel_id

  def self.create_or_update_payment(transaction_no, bill)
    @payment = Payment.find_or_initialize_by_reference_number(transaction_no)
    unless @payment.id
      @payment.hotel_id = bill.hotel_id
    end
    @payment.save ? @payment : nil
  end

  def self.is_credit_card_expiry_date_valid?(date)
    date > Date.today
  end
end
