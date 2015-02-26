class ViewMappings::UpsellMapping
  def self.map_upsell_option(reservation, room_type, upgrade_room, options = {})
    # get room nos to be upgraded. Check any of them are already assigned and reservation is due for arival. If yes then
    # do not assign
    current_room_type = reservation.current_daily_instance.room_type if !current_room_type

    if options[:inactive_room_ids].include?(upgrade_room.id)
      service_status_id = options[:inactive_rooms].select{ |r| r.id = upgrade_room.id }.map{ |s| s.ref_service_status_id }.first
    end
    upsell_amounts = reservation.hotel.upsell_amounts.where('level_from=? AND level_to=?', current_room_type.upsell_room_level.level, room_type.upsell_room_level.level).first
    option = {
      'room_id' => upgrade_room.id,
      'upsell_amount_id' => upsell_amounts.id,
      'upgrade_room_number' => upgrade_room.room_no,
      'upsell_amount' => NumberUtility.default_amount_format(upsell_amounts.amount),
      'upgrade_room_type' => room_type.room_type,
      'upgrade_room_type_name' => room_type.room_type_name,
      'upgrade_room_description' => room_type.description,
      'room_type_image' => room_type.image.url,
      'no_of_rooms' => room_type.no_of_rooms,
      'max_adults' => room_type.max_adults,
      'max_children' => room_type.max_children,
      'room_max_occupancy' => upgrade_room.max_occupancy,
      'room_type_max_occupancy' => room_type.max_occupancy,
      'room_type_level' => room_type.upsell_room_level.level,
      'is_oos' => service_status_id == options[:oo_service_status_id] ? true : false
    }
    option = Hash[*option.map { |k, v| [k, v.to_s || ''] }.flatten]
    option
  end

  def self.map_hotel_upsell_options(hotel)
    {
      'charge_codes' => hotel.charge_codes.map do |charge_code|
        {
          value: charge_code.id,
          name: "#{charge_code.charge_code} #{charge_code.description}"
        }
      end,
      'selected_charge_code' => hotel.upsell_charge_code_id,
      'upsell_setup' => {
        'currency_code' => hotel.default_currency.to_s,
        'hotel_id' => hotel.id.to_s,
        'is_force_upsell' => hotel.settings.upsell_is_force.to_s,
        'is_one_night_only' => hotel.settings.upsell_is_one_night_only.to_s,
        'is_upsell_on' => hotel.settings.upsell_is_on.to_s,
        'total_upsell_target_amount' => NumberUtility.default_amount_format(hotel.settings.upsell_total_target_amount),
        'total_upsell_target_rooms' => hotel.settings.upsell_total_target_rooms.to_s
      },
      'upsell_amounts' => hotel.upsell_amounts.map do |upsell_amount|
        {
          'amount' => NumberUtility.default_amount_format(upsell_amount.amount),
          'hotel_id' => upsell_amount.hotel_id.to_s,
          'id' => upsell_amount.id.to_s,
          'level_from' => upsell_amount.level_from.to_s,
          'level_to' => upsell_amount.level_to.to_s

        }
      end,
      'upsell_room_levels' => [1, 2, 3].map do |level_number|
        room_types = hotel.room_types.is_not_pseudo.includes(:upsell_room_level).where('upsell_room_levels.level = ?', level_number)

        {
          'level_id' => level_number.to_s,
          'room_types' => room_types.map do |room_type|
            {
              'room_type_id' => room_type.id.to_s,
              'room_type_name' => room_type.room_type_name.to_s
            }
          end
        }
      end
    }
  end

  def self.map_late_checkout_setup_and_charges(hotel)
    result = {
      'currency_code' => hotel.default_currency.to_s,
      'charge_codes' => hotel.charge_codes.map { |charge_code| { value: charge_code.id, name: "#{charge_code.charge_code} #{charge_code.description}" } },
      'room_types' => hotel.room_types.map { |room_type| {
        id: room_type.id,
        name: "#{room_type.room_type_name}",
        max_late_checkouts: room_type.max_late_checkouts ? room_type.max_late_checkouts : ''
      } }
    }

    hotel.late_checkout_charges.each_with_index do |upsell_charge, i|
      result["extended_checkout_charge_#{i}"] = {
        'time' =>  upsell_charge.extended_checkout_time.andand.strftime('%I'),
        'charge' => NumberUtility.default_amount_format(upsell_charge.extended_checkout_charge)
      }
    end

    alert_time = hotel.settings.late_checkout_upsell_alert_time.andand.in_time_zone(hotel.tz_info)

    result['is_late_checkout_set'] = hotel.settings.late_checkout_is_on.to_s
    result['allowed_late_checkout'] = hotel.settings.late_checkout_num_allowed
    result['is_exclude_guests'] = hotel.settings.late_checkout_is_pre_assigned_rooms_excluded.to_s
    result['alert_hour'] = alert_time.andand.strftime('%I')
    result['alert_minute'] = alert_time.andand.strftime('%M')
    result['selected_charge_code'] = hotel.late_checkout_charge_code_id

    result
  end

  def self.map_late_checkout_setup_config(params, hotel)
    alert_time = params['sent_alert'].present? ? ActiveSupport::TimeZone[hotel.tz_info].parse(params['sent_alert']) : nil

    {
      late_checkout_is_on: params['is_late_checkout_set'] == 'true',
      late_checkout_num_allowed: params['allowed_late_checkout'],
      late_checkout_is_pre_assigned_rooms_excluded: params['is_exclude_guests'] == 'true',
      late_checkout_upsell_alert_time: alert_time,
      late_checkout_charge_code_id: params[:charge_code],
      late_checkout_charges: params['extended_checkout'].andand.map do |value|
        LateCheckoutCharge.new(extended_checkout_time: value['time'], extended_checkout_charge: value['charge'].gsub('$', ''))
      end
    }
  end
end
