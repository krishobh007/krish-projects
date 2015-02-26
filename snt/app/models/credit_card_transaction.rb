class CreditCardTransaction < ActiveRecord::Base
  after_create  { |cc| cc.record_transaction_action(true) }
  after_update  { |cc| cc.record_transaction_action(false) }
  
  belongs_to :payment_method
  belongs_to :credit_card_transaction_type, class_name: "Ref::CreditCardTransactionType"
  belongs_to :currency_code, class_name: "Ref::CurrencyCode"
  belongs_to :hotel
  
  has_many :finacial_transactions
  
  attr_accessible :amount, :authorization_code, :currency_code_id,:req_reference_no, :external_transaction_ref, :workstation_id, 
                  :status, :hotel, :creator_id, :updater_id, :external_print_data,
                  :external_failure_reason, :emv_terminal_id, :is_swiped, :is_emv_pin_verified, :is_emv_authorized,
                  :external_message, :is_dcc, :issue_number, :merchant_id, :credit_card_transaction_type, :payment_method,
                  :sequence_number
                  
  def get_amount
    hotel ? (hotel.settings.payment_gateway == 'sixpayments' ? amount/100 : amount) : amount
  end
  
  def record_transaction_action(is_create = true)
    action_type = is_create ? :CREATE_CC_TRANSACTION : :UPDATE_CC_TRANSACTION
    action_details = []
    
    self.changes.each do |key, change|
      action_details.push({
        key: key,
        old_value: change[0],
        new_value: change[1]
      })
    end
    
    Action.record!(self, action_type, :WEB, self.hotel_id, action_details)
  end
  
  def self.get_sequence_number
    Setting.cc_request_sequence_number = 0 if Setting.cc_request_sequence_number.nil?
    Setting.cc_request_sequence_number += 1
  end
  
  def self.make_emv_payment(hotel, amount)
    credit_card_transaction = nil
    if hotel.payment_gateway == 'sixpayments'
      settlement = SixPayment::ThreeCIntegra::Processor::Settlement.new(hotel, nil)
      credit_card_transaction = settlement.process({
        :amount => amount,
        :type   => 'sale_terminal',
        :currency_code => hotel.default_currency.andand.value
      })
      return credit_card_transaction
    end
  end
  
end
