class Api::WorkSheetsController < ApplicationController
  before_filter :check_session
  before_filter :retrieve, only: [:show, :update, :destroy]
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  def index
    @work_sheets = WorkSheet.page(params[:page]).per(params[:per_page])
  end
  
  def active
    @work_types = current_hotel.work_types
    @business_date = current_hotel.active_business_date
  end

  def create
    existing_work_sheet = WorkSheet.find_by_user_id_and_work_type_id_and_date(params[:user_id], params[:work_type_id], params[:date])
    if existing_work_sheet
      render(json: [I18n.t(:work_sheet_already_exists)], status: :unprocessable_entity)
    else
      @work_sheet = WorkSheet.new(work_sheet_params)
      @work_sheet.save! || render(json: @work_sheet.errors.full_messages, status: :unprocessable_entity)
    end
  end
  
  def update
    @work_sheet.update_attributes(work_sheet_params) || render(json: @work_sheet.errors.full_messages, status: :unprocessable_entity)
  end
  
  def show
  end
  
  def destroy
    @work_sheet.work_assignments.destroy_all
    @work_sheet.destroy || render(json: @work_sheet.errors.full_messages, status: :unprocessable_entity)
  end
  
  private
  
  def work_sheet_params
    {
      user_id: params[:user_id],
      work_type_id: params[:work_type_id],
      shift_id: params[:shift_id],
      date: params[:date],
    }
  end
  
   # Retrieve the selected work sheet
  def retrieve
    @work_sheet = WorkSheet.find(params[:id])
    fail I18n.t(:access_denied) unless @work_sheet.present?
  end
  
end