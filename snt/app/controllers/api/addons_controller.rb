class Api::AddonsController < ApplicationController
  before_filter :check_session
  before_filter :check_business_date
  after_filter :load_business_date_info
  
  before_filter :retrieve, only: [:show, :update, :destroy, :activate]

  # List addons for the hotel
  def index
    page_number = params[:page] || 1
    per_page    = params[:per_page] || 10
    sort_direction = params[:sort_dir].nil? ? 'ASC' : (params[:sort_dir] == 'true' ? 'ASC' : 'DESC')
    sort_by     = params[:sort_field] || 'name'
    order_query = "#{sort_by} #{sort_direction}"

    addons_order = current_hotel.addons.order(order_query)
    @addons = params[:no_pagination] ? addons_order : addons_order.page(page_number).per(per_page)
    @no_pagination = params[:no_pagination]
    @addons = @addons.search(params, current_hotel.active_business_date)
    query = params[:query]
    if query.present?
      @addons =  @addons.where('name LIKE ? OR description LIKE ?', "%#{query}%", "%#{query}%")
    end
  end

  # Show the addon details
  def show
  end

  # Create a new addon
  def create
    @addon = Addon.new(addon_params)
    @addon.save || render(json: @addon.errors.full_messages, status: :unprocessable_entity)
  end

  # Update an existing addon
  def update
    @addon.update_attributes(addon_params) || render(json: @addon.errors.full_messages, status: :unprocessable_entity)
  end

  # Destroys a addon
  def destroy
    @addon.destroy || render(json: @addon.errors.full_messages, status: :unprocessable_entity)
  end

  # Activates or deactivates an addon for a hotel
  def activate
    @addon.update_attributes(is_active: params[:status]) || render(json: @addon.errors.full_messages, status: :unprocessable_entity)
  end

  # Enables or disables the bestseller flag for the hotel
  def bestseller
    current_hotel.settings.addon_is_bestseller = params[:status]
  end

  # Import addons from the external PMS
  def import
    current_hotel.import_addons_from_external_pms || render(json: [I18n.t(:external_pms_failed)], status: :unprocessable_entity)
  end

  private

  # Retrieve the selected addon
  def retrieve
    @addon = Addon.find(params[:id])
    fail I18n.t(:access_denied) unless @addon.hotel == current_hotel
  end

  def addon_params
    {
      name: params[:name],
      description: params[:description],
      bestseller: params[:bestseller] || false,
      charge_group_id: params[:charge_group_id],
      charge_code_id: params[:charge_code_id],
      begin_date: params[:begin_date],
      end_date: params[:end_date],
      amount: params[:amount],
      amount_type_id: params[:amount_type_id],
      post_type_id: params[:post_type_id],
      rate_code_only: params[:rate_code_only] || false,
      is_reservation_only: params[:is_reservation_only] || false,
      hotel_id: current_hotel.id
    }
  end
end
