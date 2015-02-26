class ExternalReferencesImportScheduler
  include Resque::Plugins::UniqueJob

  # Find all hotels that need to import and schedule the import job
  def self.perform
    # Work around for the MySQL server has gone away error
    ActiveRecord::Base.verify_active_connections!

    Hotel.needs_external_references_import.each do |hotel|
      Resque.enqueue(ExternalReferencesImport, hotel.id)
    end
  rescue => e
    logger.error "*******     An exception occured during external references import scheduler  #{e.message}   *******"
    ExceptionNotifier.notify_exception(e)
  end
end
