# Used to process creating room keys in a remote API
class KeyApi < ConnectKeyApi
  # send create key info
  def create_key(reservation, reservation_key, email, host_with_port, options = {})
    if @called_from_rover
      @connect_api_class_rover.create_key(@hotel_id, reservation, reservation_key, email, host_with_port, @called_from_rover, options)
    else
      @connect_api_class_zest.create_key(@hotel_id, reservation, reservation_key, email, host_with_port, @called_from_rover, options)
    end
  end
end
