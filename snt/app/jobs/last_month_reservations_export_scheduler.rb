class LastMonthReservationsExportScheduler
  include Resque::Plugins::UniqueJob

  def self.perform
    begin
      ActiveRecord::Base.verify_active_connections!
      Hotel.needs_export.each do |hotel|
        logger.info "Export sent to #{hotel.name}"
        Resque.enqueue(LastMonthReservationsExport, hotel.id)
      end
    rescue => e
      ExceptionNotifier.notify_exception(e)
    end
  end
end
