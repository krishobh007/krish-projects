class OwsRoomApi
  def self.get_room_status(hotel_id, room_type_id, room_no)
    room_service = OwsResvAdvancedService.new(hotel_id)

    message = OwsMessage.new
    message.append_hotel_reference(hotel_id)

    # If room type is passed then get room status for rooms that belong to those room type
    unless room_type_id.nil?
      message.append_room_type(hotel_id, room_type_id)
    end

    # If room number is passed then get room status for that particular room
    unless room_no.nil?
      message.append_room_no(hotel_id, room_no)
    end

    room_service.fetch_room_status message, '//FetchRoomStatusResponse', lambda { |operation_response|
      operation_response.xpath('RoomStatus').map do |room_status_tag|
        hotel = Hotel.find(hotel_id)

        {
          hk_status: ExternalMapping.map_external_system_value(hotel.pms_type, room_status_tag.xpath('@RoomStatus').text, Setting.mapping_types[:hk_status]),
          is_occupied: ExternalMapping.map_external_system_value(hotel.pms_type, room_status_tag.xpath('@FrontOfficeStatus').text, Setting.mapping_types[:fo_status]) == 'OCCUPIED' ? true : false,
          room_type_id: RoomType.where(hotel_id: hotel_id, room_type: room_status_tag.xpath('@RoomType').text).first.andand.id,
          room_no: room_status_tag.xpath('@RoomNumber').text

        }
      end
    }
  end

  def self.get_rooms(hotel_id, room_type_code)
    room_service = OwsResvAdvancedService.new(hotel_id)
    message = OwsMessage.new
    message.append_hotel_reference(hotel_id)

    # If room type is passed then get room status for rooms that belong to those room type
    unless room_type_code.nil?
      message.append_room_type(hotel_id, room_type_code)
    end

    room_service.fetch_room_setup message, '//FetchRoomSetupResponse', lambda { |operation_response|
      operation_response.xpath('RoomSetup').map do |room_setup_tag|
        # key[0]-- Room type, Key[1]- long_description, key[2]- Short Description, key[3] - Max Occupency
        { [room_setup_tag.xpath('@RoomType').text, room_setup_tag.xpath('RoomDescription/Text').text, room_setup_tag.xpath('RoomShortDescription/Text').text, room_setup_tag.xpath('@MaximumOccupancy').text, (room_setup_tag.xpath('@SuiteType').text == 'PSUEDO') ? 'true' :  'false', (room_setup_tag.xpath('@SuiteType').text == 'SUITE') ? 'true' :  'false'] => room_setup_tag.xpath('@RoomNumber').text }
      end
    }
  end

  # Change the Hk_status from House keeping smartphone app
  def self.change_room_status(hotel_id, hk_status, room_no)
    guest_service = OwsGuestServices.new(hotel_id)

    message = OwsMessage.new
    message.append_room_status(hotel_id, hk_status, room_no)

    guest_service.update_room_status message, '//UpdateRoomStatusResponse', lambda { |operation_response|
      []
    }
  end
end
