#!/usr/bin/env ruby

module MerchantLink
  module Lodging
    module Message
    
    VERSION = 'V1.7.0' 
=begin
    LTV - Root Element
    CC  - CompanyCode
    SC  - SiteCode
    LN  - LaneNumber
    T   - TranRequest
    V   - Version
    PS  - POSTranID - Unique counter
    PT  - POSTimestamp
    A   - Authorization
    C   - Capture
    FN  - FolioNumber - Hotel ID
    EM  - EntryMethod K = token
    CD  - CardData - Card Number or token
    E   - ExpDate MMYY
    AA  - AuthAmount
    CI  - CheckinTime YYYYMMDD
    CO  - CheckoutTime YYYYMMDD
    GN  - GuestName
    MLT - MLTranID
    AD  - ArrivalDate
    DD  - DepartureDate
    TA  - TotalAuthAmount
    SA  - SettleAmount
    RR  - RoomRate: Required for American Express.
=end
      
      def self.pre_auth_message(attributes)
        message = Nokogiri::XML::Builder.new do
          LTV(VID: 200) do
            CC  attributes[:company_code]
            SC  attributes[:site_code]
            LN  1234
            T do
              V VERSION
              PS attributes[:sequence_number]
              PT Time.now.utc
              A do
                FN attributes[:hotel_id]
                EM 'K'
                CD attributes[:mli_token]
                E  attributes[:expiry_date]
                AA attributes[:amount]
                CI attributes[:checkin_date]
                CO attributes[:checkout_date]
              end
            end
          end
        end
      end
      
      def self.topup_message(attributes)
        message = Nokogiri::XML::Builder.new do
          LTV(VID: 200) do
            CC  attributes[:company_code]
            SC  attributes[:site_code]
            LN  1234
            T do
              V VERSION
              PS attributes[:sequence_number]
              PT Time.now.utc
              IA do
                MLT attributes[:auth_transaction_id]
                AA  attributes[:amount]
              end
            end
          end
        end
      end
      
      def self.auth_reverse_message(attributes)
        message = Nokogiri::XML::Builder.new do
          LTV(VID: 200) do
            CC  attributes[:company_code]
            SC  attributes[:site_code]
            LN  1234
            T do
              V VERSION
              PS attributes[:sequence_number]
              PT Time.now.utc
              AV do
                MLT attributes[:auth_transaction_id]
                TA  attributes[:amount]
              end
            end
          end
        end
      end
      
      def self.settle_message(attributes)
        message = Nokogiri::XML::Builder.new do
          LTV(VID: 200) do
            CC  attributes[:company_code]
            SC  attributes[:site_code]
            LN  1234
            T do
              V VERSION
              PS attributes[:sequence_number]
              PT Time.now.utc
              C do
                GN  attributes[:guest_name]
                MLT attributes[:auth_transaction_id]
                AD  attributes[:arrival_date]
                DD  attributes[:departure_date]
                TA  attributes[:authorize_amount]
                SA  attributes[:settle_amount]
                RR  attributes[:room_rate]
              end
            end
          end
        end
      end
      
      def self.refund_message(attributes)
        message = Nokogiri::XML::Builder.new do
          LTV(VID: 200) do
            CC  attributes[:company_code]
            SC  attributes[:site_code]
            T do
              V VERSION
              PS attributes[:sequence_number]
              PT Time.now.utc
              CF do
                GN  attributes[:guest_name]
                FN  attributes[:hotel_id]
                AD  attributes[:arrival_date]
                DD  attributes[:departure_date]
                EM  'K'
                CD  attributes[:mli_token]
                E   attributes[:expiry_date]
                SA  attributes[:amount]
              end
            end
          end
        end
      end
      
    end
  end
end