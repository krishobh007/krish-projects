class OccupancyRevenueSummaryReport < ReportGenerator
  def process
    output_report(@hotel)
  end

  def output_report(hotel)
    { headers: [], results: resultant_response_data(hotel), totals: [], total_count: 0 }
  end

  def resultant_response_data(hotel)
    results = {}
    # This year begin/end  date
    begin_date = @filter[:from_date]
    end_date = @filter[:to_date]

    # Last year begin/end  date
    last_year_begin_date = @filter[:from_date] - 1.year
    last_year_end_date = @filter[:to_date] - 1.year

    # Total number of rooms exclude pseudo
    @current_hotel_rooms = hotel.rooms.exclude_pseudo

    

    is_hourly_rate_enabled_for_hotel = hotel.settings.is_hourly_rate_on

    if is_hourly_rate_enabled_for_hotel

      current_eod_time =  hotel.settings.business_date_change_time.in_time_zone(hotel.tz_info)

      current_hotel_eod_begin_time = getDatetime(@filter[:from_date], current_eod_time, hotel).utc

      current_hotel_eod_end_time = getDatetime(@filter[:to_date], current_eod_time, hotel).utc

      current_hotel_eod_end_time = begin_date == end_date ? current_hotel_eod_end_time + 1.day : current_hotel_eod_end_time

      last_year_current_hotel_eod_begin_time = current_hotel_eod_begin_time - 1.year
      last_year_current_hotel_eod_end_time = current_hotel_eod_end_time - 1.year

      daily_instances_for_this_year = hotel.daily_instances
                                    .occupancy(current_hotel_eod_begin_time, current_hotel_eod_end_time)

      daily_instances_for_last_year = hotel.daily_instances
                                    .occupancy(last_year_current_hotel_eod_begin_time, last_year_current_hotel_eod_end_time)

      occupied_rooms_for_this_year = daily_instances_for_this_year.group(:reservation_date).count
      occupied_rooms_for_last_year = daily_instances_for_last_year.group(:reservation_date).count

      daily_instances_for_comp_rooms_this_year = daily_instances_for_this_year.where('rate_amount = 0')
      daily_instances_for_comp_rooms_last_year = daily_instances_for_last_year.where('rate_amount = 0')


      # Complimentary Rooms = Rooms which contain rate_amount 0.0
      complimentary_rooms_for_this_year = daily_instances_for_comp_rooms_this_year.group(:reservation_date).count

      complimentary_rooms_for_last_year = daily_instances_for_comp_rooms_last_year.group(:reservation_date).count


      # Revenue per Available Room (RevPar): Show daily revenue per available room.
      # Total revenue divided by total number of rooms (less Pseudo or OOO rooms)
      total_revenue = daily_instances_for_this_year
                   .group(:reservation_date).sum(:rate_amount)

      # Average daily rate of all reservations for a day. (include 0.00 rates)
      adr_incl_comp_rooms_this_year = daily_instances_for_this_year
                                    .group(:reservation_date).average(:rate_amount)

      adr_incl_comp_rooms_last_year = daily_instances_for_last_year
                                    .group(:reservation_date).average(:rate_amount)

                                       # Average daily rate of all reservations for a day. (exclude 0.00 rates)
      adr_excl_comp_rooms_this_year = daily_instances_for_this_year
                                    .where('rate_amount != 0').group(:reservation_date).average(:rate_amount)
      adr_excl_comp_rooms_last_year = daily_instances_for_last_year
                                    .where('rate_amount != 0').group(:reservation_date).average(:rate_amount)



    else
      # Total Number of rooms occupied( This year and Last year)

      occupied_rooms_for_this_year = hotel.daily_instances.between_dates(begin_date, end_date)
                                   .where('room_id is not null')
                                   .group(:reservation_date).count
      occupied_rooms_for_last_year = hotel.daily_instances.between_dates(last_year_begin_date, last_year_end_date)
                                  .where('room_id is not null')
                                  .group(:reservation_date).count


      # Complimentary Rooms = Rooms which contain rate_amount 0.0
      complimentary_rooms_for_this_year = hotel.daily_instances.complimentary_rooms_between_dates(begin_date, end_date)
                                        .group(:reservation_date).count
      complimentary_rooms_for_last_year = hotel.daily_instances.complimentary_rooms_between_dates(last_year_begin_date, last_year_end_date)
                                       .group(:reservation_date).count


      # Revenue per Available Room (RevPar): Show daily revenue per available room.
      # Total revenue divided by total number of rooms (less Pseudo or OOO rooms)
      total_revenue = hotel.daily_instances.between_dates(begin_date, end_date)
                   .group(:reservation_date).sum(:rate_amount)

      # Average daily rate of all reservations for a day. (include 0.00 rates)
      adr_incl_comp_rooms_this_year = hotel.daily_instances.between_dates(begin_date, end_date)
                                    .group(:reservation_date).average(:rate_amount)
      adr_incl_comp_rooms_last_year = hotel.daily_instances.between_dates(last_year_begin_date, last_year_end_date)
                                    .group(:reservation_date).average(:rate_amount)

                                       # Average daily rate of all reservations for a day. (exclude 0.00 rates)
      adr_excl_comp_rooms_this_year = hotel.daily_instances.between_dates(begin_date, end_date)
                                    .where('rate_amount != 0').group(:reservation_date).average(:rate_amount)
      adr_excl_comp_rooms_last_year = hotel.daily_instances.between_dates(last_year_begin_date, last_year_end_date)
                                    .where('rate_amount != 0').group(:reservation_date).average(:rate_amount)
    end


    # Total number of rooms available - pseduo - OOO
    results[:available_rooms] = available_rooms(begin_date, end_date, hotel)
    results[:occupied_rooms] = occupied_rooms(begin_date, end_date, occupied_rooms_for_this_year, occupied_rooms_for_last_year)
    results[:complimentary_rooms] = complimentary_rooms(begin_date, end_date, complimentary_rooms_for_this_year, complimentary_rooms_for_last_year)
    results[:occupied_minus_comp] = occupied_minus_comp_rooms(begin_date, end_date, results[:occupied_rooms], results[:complimentary_rooms])

    results[:total_occupancy_in_percentage] = total_occupancy_in_percentage(begin_date, end_date, @current_hotel_rooms, results[:occupied_rooms])
    results[:total_occupancy_minus_comp_in_percentage] = total_occupancy_minus_comp_in_percentage(begin_date, end_date, @current_hotel_rooms, results[:occupied_minus_comp])

    results[:rev_par] = total_rev_par(begin_date, end_date, total_revenue, @current_hotel_rooms, hotel)



    results[:adr_inclusive_complimentary_rooms] = adr_calculation(begin_date, end_date, adr_incl_comp_rooms_this_year, adr_incl_comp_rooms_last_year)

    results[:adr_exclusive_complimentatry_rooms] = adr_calculation(begin_date, end_date, adr_excl_comp_rooms_this_year, adr_excl_comp_rooms_last_year)

    results[:total_revenue] = charge_group_revenue_total(begin_date, end_date, hotel)
    results[:charge_groups] = charge_code_revenue(begin_date, end_date, hotel)

    # Markets - Revenue and Room Number calculation
    results[:market_room_number] = total_number_of_rooms_for_market(begin_date, end_date, hotel)
    results[:market_revenue] = total_revenue_for_market(begin_date, end_date, hotel)

    if is_hourly_rate_enabled_for_hotel
      results[:nightly] = calculate_nightly_component(begin_date, end_date, daily_instances_for_this_year, daily_instances_for_last_year, daily_instances_for_comp_rooms_this_year, daily_instances_for_comp_rooms_last_year)
    end 


    results
  end

  def available_rooms(begin_date, end_date, hotel)
    available_room_hash = {}
    total_rooms_count =  @current_hotel_rooms.count
    out_of_order_rooms_per_date_for_this_year = hotel.rooms.out_of_order_between(begin_date, end_date).group(:date).count

    out_of_order_rooms_per_date_for_last_year = hotel.rooms.out_of_order_between(begin_date - 1.year, end_date - 1.year).group(:date).count

    (begin_date .. end_date).to_a.each do |each_date|
      avaialble_rooms_count_for_this_year = total_rooms_count - out_of_order_rooms_per_date_for_this_year[each_date].to_i
      avaialble_rooms_count_for_last_year = total_rooms_count - out_of_order_rooms_per_date_for_last_year[each_date - 1.year].to_i
      available_room_hash[each_date] =
                              {
                                this_year: avaialble_rooms_count_for_this_year,
                                last_year: avaialble_rooms_count_for_last_year
                               }
    end
    available_room_hash
  end

  def occupied_rooms(begin_date, end_date, occupied_rooms_this_year, occupied_rooms_last_year)
    occupied_rooms_hash = {}
    (begin_date .. end_date).to_a.each do |each_date|
      occupied_rooms_hash[each_date] =
                              {
                                this_year: occupied_rooms_this_year[each_date].to_i,
                                last_year: occupied_rooms_last_year[each_date - 1.year].to_i
                               }
    end
    occupied_rooms_hash
  end

  def complimentary_rooms(begin_date, end_date, complimentary_rooms_for_this_year, complimentary_rooms_for_last_year)
    complimentary_rooms_hash = {}
    (begin_date .. end_date).to_a.each do |each_date|
      complimentary_rooms_hash[each_date] =
                              {
                                this_year: complimentary_rooms_for_this_year[each_date].to_i,
                                last_year: complimentary_rooms_for_last_year[each_date - 1.year].to_i
                               }
    end
    complimentary_rooms_hash
  end

  def occupied_minus_comp_rooms(begin_date, end_date, occupied_rooms_hash, complimentary_rooms_hash)
    occupied_minus_comp_rooms_hash = {}
    (begin_date .. end_date).to_a.each do |each_date|
      occupied_minus_comp_rooms_hash[each_date] =
                              {
                                this_year: occupied_rooms_hash[each_date][:this_year].to_i - complimentary_rooms_hash[each_date][:this_year].to_i,
                                last_year: occupied_rooms_hash[each_date][:last_year].to_i - complimentary_rooms_hash[each_date][:last_year].to_i
                               }
    end
    occupied_minus_comp_rooms_hash
  end

  def total_occupancy_in_percentage(begin_date, end_date, total_rooms, occupied_rooms_hash)
    total_occupancy_per_hash = {}
    (begin_date .. end_date).to_a.each do |each_date|
      this_year = (occupied_rooms_hash[each_date][:this_year].to_i.fdiv(total_rooms.count)) * 100
      last_year = (occupied_rooms_hash[each_date][:last_year].to_i.fdiv(total_rooms.count)) * 100
      total_occupancy_per_hash[each_date] =
                             {
                               this_year: this_year,
                               last_year: last_year
                             }

    end
    total_occupancy_per_hash
  end

  def total_occupancy_minus_comp_in_percentage(begin_date, end_date, total_rooms, occpancy_minus_comp_hash)
    total_occupancy_minus_comp_in_percentage_hash = {}
    (begin_date .. end_date).to_a.each do |each_date|
      this_year = (occpancy_minus_comp_hash[each_date][:this_year].to_i.fdiv(total_rooms.count)) * 100
      last_year = (occpancy_minus_comp_hash[each_date][:last_year].to_i.fdiv(total_rooms.count)) * 100
      total_occupancy_minus_comp_in_percentage_hash[each_date] =
                                     {
                                       this_year: this_year,
                                       last_year: last_year
                                     }
    end
    total_occupancy_minus_comp_in_percentage_hash

  end

  def adr_calculation(begin_date, end_date, adr_this_year, adr_last_year)
    adr_rooms_hash = {}
    (begin_date .. end_date).to_a.each do |each_date|
     adr_rooms_hash[each_date] =
      {
        this_year: adr_this_year[each_date].to_f,
        last_year: adr_last_year[each_date - 1.year].to_f
      }
    end
    adr_rooms_hash
  end

  def total_revenue(begin_date, end_date, total_revenue)
    total_revenue_hash = {}
    (begin_date .. end_date).to_a.each do |each_date|
     total_revenue_hash[each_date] = 
     {
       this_year: total_revenue[each_date].to_f,
       last_year: total_revenue[each_date - 1.year].to_f
     }
    end
    total_revenue_hash
  end

  def charge_group_revenue_total(begin_date, end_date, hotel)
    total_revenue_hash = {}
    cc_revenue = charge_code_revenue(begin_date, end_date, hotel)
    (begin_date .. end_date).to_a.each do |each_date|
      total_revenue_hash[each_date] = {
        this_year:  ((cc_revenue.map { |x| x[each_date] }).map { |y| y[:this_year] }).inject{|sum,x| sum + x },
        last_year: ((cc_revenue.map { |x| x[each_date] }).map { |y| y[:last_year] }).inject{|sum,x| sum + x }
       }
    end
    total_revenue_hash
  end

  def total_rev_par(begin_date, end_date, total_revenue_by_date, total_rooms_including_ooo, hotel)
    total_rev_par_hash = {}
    # As per story comment - RevPar = Total Room Revenue/Total Number of Rooms(including OOO)
    # cc_revenue_total = charge_group_revenue_total(begin_date, end_date, hotel)
    (begin_date .. end_date).to_a.each do |each_date|
      this_year = total_revenue_by_date[each_date].to_f.fdiv(total_rooms_including_ooo.count)
      last_year = total_revenue_by_date[each_date - 1.year].to_f.fdiv(total_rooms_including_ooo.count)
      total_rev_par_hash[each_date] =
                                    {
                                        this_year: this_year,
                                        last_year: last_year
                                    }
     end
     total_rev_par_hash    
  end

  def charge_code_revenue(begin_date, end_date, hotel)
    charge_groups = hotel.charge_groups
    charge_code_array = []
    charge_groups.each do |charge_group|
      charge_code_ids = charge_group.charge_codes.exclude_payments.pluck(:id)
      charge_code_total_revenue_this_year = FinancialTransaction
                                            .where('date >= ? AND date <= ? AND charge_code_id IN (?)', begin_date, end_date, charge_code_ids)
                                            .group('date').sum('amount')
      charge_code_total_revenue_last_year = FinancialTransaction
                                            .where('date >= ? AND date <= ? AND charge_code_id IN (?)', begin_date - 1.year, end_date - 1.year, charge_code_ids)
                                            .group('date').sum('amount')
      charge_code_hash = {}
      charge_code_hash['id'] = charge_group.id
      charge_code_hash['name'] = charge_group.charge_group
      (begin_date .. end_date).to_a.each do |each_date|
        charge_code_hash[each_date] = {
          this_year: charge_code_total_revenue_this_year[each_date].to_f,
          last_year: charge_code_total_revenue_last_year[each_date - 1.year].to_f
         }
      end
      charge_code_array << charge_code_hash
    end
    charge_code_array
  end

  def total_number_of_rooms_for_market(begin_date, end_date, hotel)
    market_total_number_of_rooms_array = []
    hotel.market_segments.each do |market|
      total_rooms_for_market = hotel.daily_instances
                              .between_dates(begin_date, end_date)
                              .where('room_id is not null and reservations.market_segment_id in (?)', market.id).group(:reservation_date).count
      market_hash = {}
      market_hash[:id] = market.id
      market_hash[:name] = market.name
      (begin_date .. end_date).to_a.each do |each_date|
        market_hash[each_date] =
          {
            this_year: total_rooms_for_market[each_date].to_i,
            last_year: total_rooms_for_market[each_date - 1.year].to_i
          }

      end
      market_total_number_of_rooms_array << market_hash
    end


    market_total_number_of_rooms_array

  end

  def total_revenue_for_market(begin_date, end_date, hotel)
    market_total_revenue_array = []
    hotel.market_segments.each do |market|
      total_revenue_market = hotel.daily_instances.between_dates(begin_date, end_date).where('room_id is not null and reservations.market_segment_id in (?)', market.id).group(:reservation_date).sum(:rate_amount)

      market_revenue_hash = {}
      market_revenue_hash[:id] = market.id
      market_revenue_hash[:name] = market.name
      (begin_date .. end_date).to_a.each do |each_date|
        market_revenue_hash[each_date] = {
                                this_year: total_revenue_market[each_date].to_i,
                                last_year: total_revenue_market[each_date - 1.year].to_i
                               }

      end
      market_total_revenue_array << market_revenue_hash
    end


    market_total_revenue_array


  end

  def total_occ_percentage_nightly(begin_date, end_date, daily_instances_for_this_year, daily_instances_for_last_year)

  end

  def calculate_nightly_component(begin_date, end_date, daily_instances_for_this_year, daily_instances_for_last_year, complimentary_for_this_year, complimentary_last_year)
    total_occupancy_in_percentage = {}
    total_occupancy_minus_comp_in_percentage = {}
    final_hash = {}

    # Total Nightly component this year
    i = 0
    j = 0
    total_nightly_rooms_for_this_year = 0
    total_nightly_rooms_for_last_year = 0

    daily_instances_for_this_year.each do |res|
      total_nightly_rooms_for_this_year += i + 1 if res.reservation.has_nightly_component?
    end
    # Total Nightly component last year
    daily_instances_for_last_year.each do |res|
      total_nightly_rooms_for_last_year += j + 1 if res.reservation.has_nightly_component?
    end

    i = 0
    j = 0
    total_nightly_comp_rooms_this_year = 0
    complimentary_for_this_year.each do |res|
      total_nightly_comp_rooms_this_year += i + 1 if res.reservation.has_nightly_component?
    end
    total_nightly_comp_rooms_last_year = 0
    complimentary_last_year.each do |res|
      total_nightly_comp_rooms_last_year += j + 1 if res.reservation.has_nightly_component?
    end

    total_rooms_count = @current_hotel_rooms.count

      (begin_date .. end_date).to_a.each do |each_date|
        total_occupancy_in_percentage[each_date] = 
        {
           this_year: (total_nightly_rooms_for_this_year.fdiv(total_rooms_count)) * 100,
           last_year: (total_nightly_rooms_for_last_year.fdiv(total_rooms_count)) * 100
        }

        total_occupancy_minus_comp_in_percentage[each_date] =
        {
           this_year: (total_nightly_comp_rooms_this_year.fdiv(total_rooms_count)) * 100,
           last_year: (total_nightly_comp_rooms_last_year.fdiv(total_rooms_count)) * 100
        }
      end
    final_hash['total_occupancy_in_percentage']  = total_occupancy_in_percentage
    final_hash['total_occupancy_minus_comp_in_percentage']  = total_occupancy_minus_comp_in_percentage

    final_hash
  end

   def getDatetime(date, time, hotel)
    ActiveSupport::TimeZone[hotel.tz_info].parse(date.to_s + ' ' + time.to_s)
  end

end
