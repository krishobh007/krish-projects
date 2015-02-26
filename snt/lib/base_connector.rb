class BaseConnector
  def initialize(api_req_data)
    @api_req_data = api_req_data
  end

  def checkin
    # Default Behaviour for Checkin
  end

  def checkout
     # Default Behaviour for Checkout
  end
end
