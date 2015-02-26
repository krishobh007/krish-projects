class Admin::PaymentTypesController < ApplicationController
  before_filter :check_session
  
  def index
    data, errors, status = {}, [], SUCCESS
    payment_types = Ref::PaymentType.all
    response_attr = {data: payment_types, errors: errors, status: status}
    render json: response_attr
  end
  
  def show
    payment_type = Ref::PaymentType.find(params[:id])
    response_attr = {data: payment_type, errors: [], status: SUCCESS}
    #render json: response_attr
    render partial: '/admin/hotel_payment/edit_payment', locals: {data: payment_type}
  end
  
  def save
    data, errors, status, attributes = {}, [], FAILURE, {}
    payment_type = params[:id].present? ?   Ref::PaymentType.find(params[:id]) : Ref::PaymentType.new
    attributes[:value] = params[:value] if params[:value]
    attributes[:is_selectable] = false
    attributes[:description] = params[:description] if params[:description]
    Ref::PaymentType.enumeration_model_updates_permitted = true
    payment_type.update_attributes!(attributes)
    Ref::PaymentType.enumeration_model_updates_permitted = false
    status = SUCCESS
    response_attr = {data: data, errors: errors, status: status}
    render json: response_attr
  end
  
  def destroy
    data, errors, status = {}, [], FAILURE
    begin
      Ref::PaymentType.find(params[:id]).delete
      status = SUCCESS
    rescue Exception=>ex
       errors << ex.message
    end 
    response_attr = {data: data, errors: errors, status: status}
    render json: response_attr
  end
  
end