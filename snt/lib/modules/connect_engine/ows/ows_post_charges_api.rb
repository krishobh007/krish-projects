class OwsPostChargesApi
  def self.update_post_charges(hotel_id, account_charge_code, external_id,  posting_attr)
    res_adv_service = OwsResvAdvancedService.new(hotel_id)

    message = OwsMessage.new

    # Append action attribute along with request
    message.append_account_no(hotel_id, account_charge_code)

    # Append Posting attributes
    message.append_posting_reservation_request_late_checkout(hotel_id, external_id, posting_attr)

    res_adv_service.post_charge message, '//PostChargeResponse'
  end
end
