# Return the deposit report
class DepositReport < DepositsReportGenerator
  def process
    reservations = reservations_query
    output_report(reservations)
  end
end