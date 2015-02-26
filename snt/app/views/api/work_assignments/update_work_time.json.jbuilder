json.begin_time  @work_assignment.begin_time
json.end_time	 @work_assignment.end_time
hk_status = @work_assignment.andand.task.andand.ref_housekeeping_status.to_s
json.task_completion_status hk_status.present? ? hk_status : Ref::HousekeepingStatus[:CLEAN].to_s