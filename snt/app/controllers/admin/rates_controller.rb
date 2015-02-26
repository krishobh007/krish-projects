class Admin::RatesController < ApplicationController
  before_filter :check_session

  layout 'admin'

  # GET /admin/rates
  # GET /admin/rates.json
  def index
    rates = current_hotel.rates.order('rate_desc')

    data = {
      'is_import_available' => current_hotel.is_third_party_pms_configured?.to_s,
      'rates' => rates.map do |rate|
        {
          'id' => rate.id,
          'description' => rate.rate_desc,
          'name' => rate.rate_name,
          'code' => rate.rate_code,
          'begin_date' => rate.begin_date,
          'end_date' => rate.end_date
        }
      end,
      'business_date' => current_hotel.active_business_date
    }

    response = { status: SUCCESS, data: data,  errors: nil }

    respond_to do |format|
      format.html { render partial: 'rates_list', locals: response }
      format.json { render json: response }
    end
  end

  # GET /admin/rates/new
  # GET /admin/rates/new.json
  def new
    data = {}

    response = { status: SUCCESS, data: data,  errors: nil }

    respond_to do |format|
      format.html { render partial: 'add_rate', locals: response }
      format.json { render json: response }
    end
  end

  # GET /admin/rates/1/edit
  def edit
    rate = current_hotel.rates.find(params[:id])

    data = {
      'id' => rate.id,
      'description' => rate.rate_desc,
      'name' => rate.rate_name,
      'begin_date' => rate.begin_date,
      'end_date' => rate.end_date
    }

    response = { status: SUCCESS, data: data,  errors: [] }

    respond_to do |format|
      format.html { render partial: 'edit_rate', locals: response }
      format.json { render json: response }
    end
  end

  # POST /admin/rates
  # POST /admin/rates.json
  def create
    rate_attributes = {
      hotel_id: current_hotel.id,
      rate_desc: params[:description],
      rate_name: params[:name],
      begin_date: params[:begin_date],
      end_date: params[:end_date]
    }

    rate = Rate.new(rate_attributes)

    if rate.save
      response = { 'status' => SUCCESS, 'data' => nil, 'errors' => nil }
    else
      response = { 'status' => FAILURE, 'data' => nil, 'errors' => rate.errors.full_messages }
    end

    respond_to do |format|
      format.html { render locals: response }
      format.json { render json: response }
    end
  end

  # PUT /admin/rates/1
  # PUT /admin/rates/1.json
  def update
    rate = current_hotel.rates.find(params[:id])

    rate_attributes = {
      rate_desc: params[:description],
      rate_name: params[:name],
      begin_date: params[:begin_date],
      end_date: params[:end_date]
    }

    rate.attributes = rate_attributes

    if rate.save
      response = { 'status' => SUCCESS, 'data' => nil, 'errors' => nil }
    else
      response = { 'status' => FAILURE, 'data' => nil, 'errors' => rate.errors.full_messages }
    end

    respond_to do |format|
      format.html { render locals: response }
      format.json { render json: response }
    end
  end

  # GET /admin/rates/import
  def import
    errors = []

    unless current_hotel.import_rates_from_external_pms
      errors << I18n.t(:external_pms_failed)
    end

    response = { 'status' => errors.empty? ? SUCCESS : FAILURE, 'data' => nil, 'errors' => errors }

    respond_to do |format|
      format.html { render locals: response }
      format.json { render json: response }
    end
  end
end
