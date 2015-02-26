class Api::MaintenanceReasonsController < ApplicationController
  before_filter :check_session
  before_filter :retrieve, only: [:update, :destroy]
  before_filter :check_business_date
  # Method to list hotel maintenance reasons
  def index
    @maintenance_reasons = current_hotel.maintenance_reasons
  end
  # Method to create hotel maintenance reasons
  def create
    @maintenance_reason = current_hotel.maintenance_reasons.new(maintenance_reason: params[:name])
    @maintenance_reason.save || render(json: @maintenance_reason.errors.full_messages, status: :unprocessable_entity)
  end
   # Method to update hotel maintenance reason
  def update
    @maintenance_reason.update_attributes(maintenance_reason: params[:name]) || render(json: @maintenance_reason.errors.full_messages, status: :unprocessable_entity)
  end
  # Method to delete hotel maintenance reason
  def destroy
    @maintenance_reason.destroy || render(json: @maintenance_reason.errors.full_messages, status: :unprocessable_entity)
  end
  
  private
  # Retrieve the selected rate
  def retrieve
    @maintenance_reason = current_hotel.maintenance_reasons.find(params[:id])
    fail I18n.t(:access_denied) unless @maintenance_reason.present?
  end
  
end
