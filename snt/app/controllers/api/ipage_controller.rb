class Api::IpageController < ApplicationController
  before_filter :check_session, only: [:index]
  before_filter :check_six_configuration
  
  def index
    @hotel = current_hotel
    @service_action = params[:service_action] || "createtoken"
    @amount = params[:amount] || 0 # Remove the 10 after test
    @amount = (@amount.to_f * 100).to_i
    @card_holder_first_name = params[:card_holder_first_name]
    @card_holder_last_name = params[:card_holder_last_name]
    
    if @service_action == 'pay'
      @credit_card_transaction = CreditCardTransaction.create(
        :amount     => @amount,
        :hotel      => current_hotel,
        :creator_id => current_user.id
      )
    end
    
    @currency_code = params[:currency_code] || current_hotel.default_currency.andand.value
    render 'api/ipage/index', :layout => false
  end
  

  private
  
  def check_six_configuration
    raise SixPayment::Web2Pay::Web2PayClientError, 'Six payment configuration is not present' if current_hotel.settings.six_merchant_id.nil? &&  current_hotel.settings.six_validation_code.nil?
    
    raise "Currency code is not supplied or configured for the hotel" unless (params.has_key?(:currency_code) || current_hotel.default_currency.present?)
  end
end