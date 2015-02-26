class Api::WorkLogsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :retrieve, only: [:update]
  before_filter :check_business_date
  
  def create
    @work_log = WorkLog.new(work_log_params)
    @work_log.save! || render(json: @work_log.errors.full_messages, status: :unprocessable_entity)
  end

  def update
    @work_log.update_attributes!(work_log_update_params) || render(json: @work_log.errors.full_messages, status: :unprocessable_entity)
  end

  private

  def work_log_params
    {
      room_id: params[:room_id],
      begin_time: Time.now
    }
  end

  def work_log_update_params
    {
      room_id: params[:room_id],
      end_time: Time.now
   }
  end

  # Retrieve the selected work log
  def retrieve
    @work_log = WorkLog.find(params[:id])
    fail I18n.t(:access_denied) unless @work_log.present?
  end
end
