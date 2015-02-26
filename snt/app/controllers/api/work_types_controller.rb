class Api::WorkTypesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  def index
    @work_types = current_hotel.work_types.page(params[:page]).per(params[:per_page]).order('is_system DESC')
  end

  def create
    @work_type = WorkType.new(work_type_params)
    @work_type.save || render(json: @work_type.errors.full_messages, status: :unprocessable_entity)
  end
  
  def show
    @work_type = WorkType.find(params[:id])
  end

  def update
    @work_type = WorkType.find(params[:id])
    @work_type.update_attributes(work_type_params) || render(json: @work_type.errors.full_messages, status: :unprocessable_entity)
  end

  def destroy
    @work_type = WorkType.find(params[:id])
    @work_type.destroy || render(json: @work_type.errors.full_messages, status: :unprocessable_entity)
  end

  private

  def work_type_params
    { name: params[:name],
      is_active: params[:is_active],
      hotel_id: params[:hotel_id] }
  end
end
