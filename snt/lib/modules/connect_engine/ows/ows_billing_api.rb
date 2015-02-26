class OwsBillingApi
  def self.get_invoice(hotel_id, resv_name_id)
    billing_service = OwsResvAdvancedService.new(hotel_id)

    message = OwsMessage.new

    message.append_reservation_request(hotel_id, resv_name_id) unless resv_name_id.nil?

    billing_service.invoice message, '//InvoiceResponse', lambda { |operation_response|
      bill_info = []
      operation_response.xpath('Invoice').each do |invoice_tag|

        bill_items = []
        invoice_tag.xpath('BillItems').each do |bill_items_tag|
          bill_items << {
            date: bill_items_tag.xpath('@Date').text,
            amount: bill_items_tag.xpath('Amount').text,
            currency_code: bill_items_tag.xpath('Amount/@currencyCode').text,
            revenue_group: bill_items_tag.xpath('RevenueGroup').text,
            transaction_no: bill_items_tag.xpath('@TransactionNo').text.present? ? bill_items_tag.xpath('@TransactionNo').text : bill_items_tag.xpath('VatCode').text,
            charge_code_description: bill_items_tag.xpath('@Description').text,
            charge_code: bill_items_tag.xpath('@TransactionCode').text
          }
        end

        bill_info << {
          bill_no: invoice_tag.xpath('BillNumber').text,
          bill_items: bill_items
        }
      end

      bill_info
    }
  end
  
  #*******************************
  # OWS API for FolioTransactionTransfer
  # Service : ResvAdvanced
  #*******************************
  
  def self.folio_transaction_transfer(hotel_id, resv_name_id, options)
    res_adv_service = OwsResvAdvancedService.new(hotel_id)
    
    message = OwsMessage.new
    message.append_reservation_request(hotel_id, resv_name_id) if !resv_name_id.nil?
    message.append_folio_transaction_transfer_attributes(options) if !resv_name_id.nil?
    res_adv_service.folio_transaction_transfer message, '//FolioTransactionTransferResponse'
  end
end