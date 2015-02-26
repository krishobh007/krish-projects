class SmartbandImportScheduler
  include Resque::Plugins::UniqueJob

  @queue = :Smartband_Import_Scheduler

  # Find all hotels that need to import and schedule the import job
  def self.perform
    begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      Hotel.needs_smartband_import.each do |hotel|
        Resque.enqueue(SmartBandImport, hotel.id)
      end
    rescue => e
      ExceptionNotifier.notify_exception(e)
    end
  end
end
