class OperaConnector < BaseConnector
  def initialize(api_req_data)
    super(api_req_data)
  end

  def checkin(reservation_name_id, hotel_code, chain_code)
    # TODO : Business Logic for Checkin. Sample place holder app for checkin request
    reservation_name_id = reservation_name_id
    hotel_code = hotel_code
    chain_code = chain_code
    message = { room_number: rand(101..150), room_type: 'KING', booking_time: Time.now, key_track: '1231223123123112' }

    message
  end

  def checkout
    # TODO: Checkout API code logic will be replaced.
  end
end
