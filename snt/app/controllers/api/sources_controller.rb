class Api::SourcesController < ApplicationController
  before_filter :check_session
  before_filter :set_source, only: [:update, :destroy]
  after_filter :load_business_date_info
  before_filter :check_business_date
  # Method to list all sources for a hotel
  def index
    @sources = current_hotel.sources
    @sources = @sources.active if params[:is_active] == 'true'
    @is_use_sources = current_hotel.settings.use_sources
  end
  # Method to create source for a hotel
  def create
    @source = current_hotel.sources.new(code: params[:name], description: params[:description], is_active: true)
    @source.save || render(json: @source.errors.full_messages, status: :unprocessable_entity)
  end
  # Method to update a source
  def update
    @source.update_attributes(code: params[:name], description: params[:description], is_active: params[:is_active])  ||
      render(json: @source.errors.full_messages, status: :unprocessable_entity)
  end
  # Method to delete a source
  def destroy
    @source.delete || render(json: @source.errors.full_messages, status: :unprocessable_entity)
  end
  # Method to enable/disable all sources
  def use_sources
    current_hotel.settings.use_sources = params[:is_use_sources]
  end

  private

  def set_source
    @source = current_hotel.sources.find(params[:id])
    fail I18n.t(:invalid_source_id) unless @source.present?
  end
end
