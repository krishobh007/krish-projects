# Methods for all guests related reports to use for generating
class DepositsReportGenerator < ReportGenerator
  # Build the query to obtain the list of reservations
  def reservations_query
    hotel_reservations = @hotel.reservations
      .joins('INNER JOIN reservations_guest_details ON reservations_guest_details.reservation_id = reservations.id')
      .joins(:daily_instances).joins('LEFT OUTER JOIN rooms ON reservation_daily_instances.room_id = rooms.id').uniq
    
    if @filter[:arrival_from_date].present? && @filter[:arrival_to_date].present?
      hotel_reservations = hotel_reservations.where('? <= arrival_date and arrival_date <= ?', @filter[:arrival_from_date], @filter[:arrival_to_date])
    end

    if @filter[:deposit_from_date].present? && @filter[:deposit_to_date].present?
      reservation_id=[]
      hotel_reservations.map do |reservation|
        if @filter[:deposit_from_date].to_date <= reservation.deposit_due_date.to_date && reservation.deposit_due_date.to_date <= @filter[:deposit_to_date].to_date
          reservation_id << reservation.id
        end 
      end
      hotel_reservations = hotel_reservations.where('reservations.id IN (?)', reservation_id)
    end
    reservations = hotel_reservations
                         .joins('INNER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id AND reservations_guest_details.is_primary').uniq
    reservations = remove_deposit_not_required(reservations,hotel_reservations)
    length = 0
    if @filter[:deposit_paid]
      length += 1
    end
    if @filter[:deposit_due]
      length += 1
    end
    if @filter[:deposit_past]
      length += 1
    end

    if length == 1
      reservations = filter_by_paid(reservations,hotel_reservations) if @filter[:deposit_paid]
      reservations = filter_by_due(reservations,hotel_reservations) if @filter[:deposit_due]
      reservations = filter_by_passed(reservations,hotel_reservations) if @filter[:deposit_past]
    elsif length == 2
      reservations = filter_by_not_paid(reservations,hotel_reservations) if !@filter[:deposit_paid]
      reservations = filter_by_not_due(reservations,hotel_reservations) if !@filter[:deposit_due]
      reservations = filter_by_not_passed(reservations,hotel_reservations) if !@filter[:deposit_past]
    end

    if @filter[:sort_field] == 'NAME'
      reservations = reservations.order("guest_details.last_name #{@sort_order}, guest_details.first_name #{@sort_order}")
    elsif @filter[:sort_field] == 'RESERVATION'
      reservations = reservations.order("reservations.confirm_no #{@sort_order}")
    elsif @filter[:sort_field] == 'DATE'
      reservations = reservations.order("reservations.arrival_date #{@sort_order}")
    elsif @filter[:sort_field] == 'DUE_DATE_RANGE'
      if "#{@sort_order}" == "asc"
        reservations = reservations.sort_by { |k| k[:due_date] }
      else
        reservations = reservations.sort_by { |k| k[:due_date] }.reverse
      end
    elsif @filter[:sort_field] == 'PAID_DATE_RANGE'
      if "#{@sort_order}" == "asc"
        reservations = reservations.sort_by { |k| k[:paid_date] }
      else
        reservations = reservations.sort_by { |k| k[:paid_date] }.reverse
      end
    end

    get_total_amounts(reservations)

    if reservations.is_a?(Array)
      Kaminari.paginate_array(reservations).page(@filter[:page]).per(@filter[:per_page])
    else
      reservations.page(@filter[:page]).per(@filter[:per_page])
    end
  end

 def remove_deposit_not_required(reservations,hotel_reservations)
   remove_ids =[]
   hotel_reservations.map do |reservation|
     if reservation.deposit_payment_status == "DEPOSIT_NOT_NEEDED"
       remove_ids << reservation.id
     end
   end
   reservations_paid = reservations.where('reservations.id NOT IN (?)',remove_ids)
 end

 def filter_by_paid(reservations,hotel_reservations)
   paid_ids =[]
   hotel_reservations.map do |reservation|
     if reservation.deposit_payment_status == "PAID"
       paid_ids << reservation.id
     end
   end
   reservations_paid = reservations.where('reservations.id IN (?)',paid_ids)
 end

def filter_by_not_paid(reservations,hotel_reservations)
   paid_ids =[]
   hotel_reservations.map do |reservation|
     if reservation.deposit_payment_status == "PAID"
       paid_ids << reservation.id
     end
   end
   reservations_not_paid = reservations.where('reservations.id NOT IN (?)',paid_ids)
 end
 

 def filter_by_due(reservations,hotel_reservations)
   due_ids =[]
   hotel_reservations.map do |reservation|
     if reservation.deposit_payment_status == "DUE"
       due_ids << reservation.id
     end
   end
   reservations_due = reservations.where('reservations.id IN (?)',due_ids)
 end

 def filter_by_not_due(reservations,hotel_reservations)
   due_ids =[]
   hotel_reservations.map do |reservation|
     if reservation.deposit_payment_status == "DUE"
       due_ids << reservation.id
     end
   end
   reservations_not_due = reservations.where('reservations.id NOT IN (?)',due_ids)
 end


 def filter_by_passed(reservations,hotel_reservations)
   passed_ids =[]
   hotel_reservations.map do |reservation|
     if reservation.deposit_payment_status == "PASSED"
       passed_ids << reservation.id
     end
   end
   reservations_passed = reservations.where('reservations.id IN (?)',passed_ids)
 end

 def filter_by_not_passed(reservations,hotel_reservations)
   passed_ids =[]
   hotel_reservations.map do |reservation|
     if reservation.deposit_payment_status == "PASSED"
       passed_ids << reservation.id
     end
   end
   reservations_not_passed = reservations.where('reservations.id NOT IN (?)',passed_ids)
 end

 def get_total_amounts(reservations)
   @paid_total = 0
   @due_total = 0
   @passed_total = 0
   reservations.map do |reservation|
     amount = reservation.andand.deposit_policy.andand.amount.to_f
     amount = 0 unless amount.present?
     deposit_status = reservation.deposit_payment_status
     if deposit_status == "PAID"
        @paid_total += reservation.andand.calculate_deposit_paid_before_checkin.to_f.round(2)
     elsif deposit_status ==  "DUE"
        @due_total += reservation.andand.balance_deposit_amount.to_f.round(2)
     elsif deposit_status ==  "PASSED"
        @passed_total += reservation.andand.balance_deposit_amount.to_f.round(2)
     end
   end
 end

  # Construct the results using the provided list of reservations
 def construct_results(reservations)
    currency_symbol = reservations.first.hotel.andand.default_currency.andand.symbol if reservations.present?
    reservations.map do |reservation|
      current_daily_instance = reservation.current_daily_instance
      primary_guest = reservation.primary_guest
      accompanying_guests = reservation.accompanying_guests if @filter[:show_guests]
      addtional_guest_counts = reservation.accompanying_guests.count.to_i
      total_guest_count = 1 + addtional_guest_counts
      company_name = reservation.company.andand.account_name
      travel_agent_name = reservation.travel_agent.andand.account_name
      group_name =  current_daily_instance.group.andand.name
      due_date = reservation.deposit_due_date if reservation.present?
      deposit_status = reservation.deposit_payment_status
      deposited_date = reservation.financial_transactions.last.date if reservation.financial_transactions.present?
      @currency_symbol = currency_symbol
      result = {
        name: primary_guest.last_first,
        reservation_no: reservation.confirm_no,
        arrival_date: ApplicationController.helpers.formatted_date(reservation.arrival_date),
        arrival_time: reservation.arrival_time.andand.in_time_zone(@hotel.tz_info).andand.strftime('%I:%M %p'),
        paid_date: deposited_date,
        paid_amount: reservation.andand.calculate_deposit_paid_before_checkin.to_f.round(2),
        due_date: ApplicationController.helpers.formatted_date(due_date),
        company_name: company_name,
        travel_agent_name: travel_agent_name,
        group_name: group_name,
        deposit_payment_status: deposit_status,
        payment_method: reservation.valid_primary_payment_method.andand.payment_type.andand.value,
        deposit_due_amount: reservation.andand.balance_deposit_amount.to_f.round(2)
       }
      result
    end
  end

  def summary_counts(paid,due,passed,currency)
    summary_counts = {
      total_deposit_paid: paid.to_f.round(2),
      total_deposit_due: due.to_f.round(2),
      total_deposit_passed: passed.to_f.round(2),
      currency: currency
      }
  end

  def output_report(reservations)
    { headers: [],sub_headers: [:reservation_no, :guest_name, :arrival, nil,  :due_date, :paid_date ], results: construct_results(reservations), totals: [],total_count: reservations.total_count, summary_counts: summary_counts(@paid_total, @due_total, @passed_total, @currency_symbol) }
  end
end
