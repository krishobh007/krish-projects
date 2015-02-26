class PostChargesApi < ConnectEngineApi
  def update_post_charges(account_charge_code, external_id,  posting_attr)
    @connect_api_class.update_post_charges(@hotel_id, account_charge_code, external_id,  posting_attr)
  end
end
