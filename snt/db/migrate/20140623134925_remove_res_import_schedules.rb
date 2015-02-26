class RemoveResImportSchedules < ActiveRecord::Migration
  def change
    Resque.get_schedules.select { |k, v| k.start_with?('res_import') }.each { |k, v| Resque.remove_schedule(k) }
    Resque.redis.del 'queue:Reservation_Import'
  end
end
