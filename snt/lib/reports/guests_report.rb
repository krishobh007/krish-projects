# Methods for all guests related reports to use for generating
class GuestsReport < ReportGenerator
  # Build the query to obtain the list of reservations
  def reservations_query(is_from_arrival = false, is_from_inhouse = false, is_from_cancel = false)
    @total_balance = 0
    @total_adult = 0
    @total_children = 0
    @adr = 0
    reservations = @hotel.reservations
      .joins('INNER JOIN reservations_guest_details ON reservations_guest_details.reservation_id = reservations.id')
      .joins('INNER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id AND reservations_guest_details.is_primary')
      .joins(:daily_instances).joins('LEFT OUTER JOIN rooms ON reservation_daily_instances.room_id = rooms.id')

    reservations = reservations.where('guest_details.is_vip') if @filter[:vip_only]  
    if is_from_inhouse
      reservations = reservations.with_status(:CHECKEDIN).where('reservation_daily_instances.reservation_date = ?', @hotel.active_business_date)
      reservation_ids = reservations.pluck(:id)
      bills = Bill.where('bill_number = 1 and reservation_id in (?)', reservation_ids)
      bills.each do |bill|
        @total_balance += bill.andand.current_balance.to_f
      end
      @total_adult = reservations.sum(:adults)
      @total_children = reservations.sum(:children).to_i + reservations.sum(:infants).to_i
      @total_room_count = reservations.where('room_id is not null').count
    end

    reservations = reservations.page(@filter[:page]).per(@filter[:per_page]) unless is_from_arrival


    if @filter[:sort_field] == 'NAME'
      reservations = reservations.order("guest_details.last_name #{@sort_order}, guest_details.first_name #{@sort_order}")

    elsif @filter[:sort_field] == 'ROOM'
      reservations = reservations.order("rooms.room_no #{@sort_order}")
    end

    reservations
  end

  # Construct the results using the provided list of reservations
 def construct_results(reservations)
    @arrivals = 0
    currency_symbol = reservations.first.hotel.andand.default_currency.andand.symbol if reservations.present?
    reservations.map do |reservation|
      daily_instance = reservation.current_daily_instance
      accompanying_guests = []
      current_daily_instance = reservation.current_daily_instance
      primary_guest = reservation.primary_guest
      accompanying_guests = reservation.accompanying_guests if @filter[:show_guests]
      addtional_guest_counts = reservation.accompanying_guests.count.to_i
      total_guest_count = 1 + addtional_guest_counts
      adr = @hotel.is_third_party_pms_configured? ? reservation.average_rate_amount : reservation.standalone_average_rate_amount
      addtional_adults_counts = daily_instance.andand.adults.to_i
      addtional_children_counts = daily_instance.andand.children.to_i + daily_instance.andand.infants.to_i
      company_name = reservation.company.andand.account_name
      travel_agent_name = reservation.travel_agent.andand.account_name
      guarantee_type = reservation.guarantee_type
      balance = reservation.bills.find_by_bill_number(1).andand.current_balance.to_f
      add_ons = reservation.addons.pluck(:name)
      group_name =  current_daily_instance.andand.group.andand.name
      @arrivals += 1 if current_daily_instance.andand.room.present?
      @currency_symbol = currency_symbol
      guarantee_type = @hotel.is_third_party_pms_configured? ? reservation.guarantee_type : reservation.reservation_type.andand.description
      result = {
        room_no: current_daily_instance.andand.room.andand.room_no || '',
        status: reservation.calculated_status.upcase,
        name: primary_guest.last_first,
        confirm_no: reservation.confirm_no,
        is_vip: primary_guest.is_vip,
        arrival_date: ApplicationController.helpers.formatted_date(reservation.arrival_date),
        arrival_time: reservation.arrival_time.andand.in_time_zone(@hotel.tz_info).andand.strftime('%I:%M %p'),
        departure_date: ApplicationController.helpers.formatted_date(reservation.dep_date),
        departure_time: reservation.departure_time.andand.in_time_zone(@hotel.tz_info).andand.strftime('%I:%M %p'),
        total_time: @hotel.settings.is_hourly_rate_on ? reservation.total_hours : reservation.total_nights,
        room_type: current_daily_instance.andand.room_type.andand.room_type_name,
        rate: current_daily_instance.andand.rate.andand.rate_name || '',
        adr: NumberUtility.default_amount_format(adr),
        cancel_date: reservation.cancel_date ? ApplicationController.helpers.formatted_date(reservation.cancel_date) : nil,
        cancel_penalty: NumberUtility.default_amount_format(reservation.rate_cancellation_penalty),
        cancel_reason: reservation.cancel_reason,
        accompanying_names: accompanying_guests.map(&:last_first),
        addtional_guest_counts: total_guest_count,
        addtional_adults_counts: addtional_adults_counts,
        addtional_children_counts: addtional_children_counts,
        company_name: company_name,
        travel_agent_name: travel_agent_name,
        balance_amount: NumberUtility.default_amount_format(balance),
        add_ons: add_ons,
        group_name: group_name,
        guarantee_type: guarantee_type
      }

      if @filter[:include_notes]
        result[:notes] = reservation.notes.order('created_at desc').map do |note|
          {
            date: ApplicationController.helpers.formatted_date(note.created_at),
            name: note.user.andand.full_name,
            note: note.description
          }
        end
      end

      result
    end
  end

  def summary_counts(total_adult, total_children, total_balance, currency, adr, arrivals,total_count)
    summary_counts = {
      total_rooms_count: total_count,
      total_adults: total_adult,
      total_children: total_children,
      total_balance: total_balance,
      currency: currency,
      adr: adr,
      arrivals: arrivals
    }
  end

  def output_report(reservations, adr = nil, total_room_count = nil, sub_headers = nil)
    arrivals = total_room_count ? total_room_count : @arrivals
    total_room_count = @total_room_count 
    adr = NumberUtility.default_amount_format(adr) if adr
  	@total_balance = NumberUtility.default_amount_format(@total_balance)
    default_sub_headers = [:room, :guest_name, :arrival, :departure, :rate, :balance]
    sub_headers = sub_headers.present? ? sub_headers : default_sub_headers
    { headers: [],sub_headers: sub_headers, results: construct_results(reservations), totals: [],total_count: reservations.total_count, summary_counts: summary_counts(@total_adult, @total_children, @total_balance, @currency_symbol, adr, arrivals, total_room_count) }
  end
end
