class Admin::HotelBrandsController < ApplicationController
  before_filter :check_session

  # GET /hotel_brands
  # GET /hotel_brands.json
  def index
    brands = HotelBrand.all
    data = {}
    data[:brands] = brands.map { |brand| { value: brand.id.to_s, name: brand.name } } if brands
    respond_to do |format|
      format.html { render partial: 'brands_list', locals: { data: data,  errors: [] } }
      format.json { render json: {data: data, status: SUCCESS, errors: []} }
    end
  end

  # GET /hotel_brands/new
  # GET /hotel_brands/new.json
  def new
    chains = HotelChain.all
    data = {}
    data[:chains] = chains.map { |chain| { value: chain.id.to_s, name: chain.name } } if chains
    respond_to do |format|
      format.html { render partial: 'add_brand_details', locals: { data: data,  errors: [] } }
      format.json { render json: {data: data, errors: [], status: SUCCESS} }
    end
  end

  # GET /hotel_brands/1/edit
  # GET /hotel_brands/1/edit.json
  def edit
    status, errors, data = SUCCESS, [], {}
    brand = HotelBrand.find(params[:id])
    chains = HotelChain.all
    data = { value: brand.id.to_s, name: brand.name, hotel_chain_id: brand.hotel_chain_id.to_s }
    data[:chains] = chains.map { |chain| { value: chain.id.to_s, name: chain.name } } if chains

    respond_to do |format|
      format.html { render partial: 'edit_brand_details', locals: { data: data,  errors: errors } }
      format.json { render json: {data: data, status: SUCCESS, errors: []} }
    end
  end

  # POST /hotel_brands
  # POST /hotel_brands.json
  def create
    hotel_brand = HotelBrand.new(name: params[:name])
    hotel_brand.hotel_chain_id = params[:hotel_chain_id]
    if hotel_brand.save
      response =  { 'status' => SUCCESS, 'data' => {}, 'errors' => [] }
    else
      response =  { 'status' => FAILURE, 'data' => {}, 'errors' => hotel_brand.errors.full_messages }
    end
    render json: response
  end

  # PUT /hotel_brands/1
  # PUT /hotel_brands/1.json
  def update
    errors, status = [], SUCCESS

    hotel_brand = HotelBrand.find(params[:id])
    hotel_brand.hotel_chain_id = params[:hotel_chain_id]
    unless hotel_brand.update_attributes(name: params[:name])
      errors, status = hotel_brand.errors.full_messages, FAILURE
    end

    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end
end
