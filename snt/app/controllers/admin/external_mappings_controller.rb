class Admin::ExternalMappingsController < ApplicationController
  before_filter :check_session
  before_filter :set_mapping_types

  def set_mapping_types
    @mapping_types = [
      Setting.mapping_types[:address_type],
      Setting.mapping_types[:email_type],
      Setting.mapping_types[:phone_type],
      Setting.mapping_types[:membership_class],
      Setting.mapping_types[:preference_value],
      Setting.mapping_types[:membership_type],
      Setting.mapping_types[:preference_type],
      Setting.mapping_types[:credit_card_type],
      Setting.mapping_types[:vip_exclusion]
    ]
  end

  def list_mappings
    data, errors, status = {}, [], FAILURE

    if params[:hotel_id]
      hotel = Hotel.find(params[:hotel_id])

      data[:hotel_id] = hotel.id.to_s
      data[:disable_mappings] = hotel.pms_type.nil?
      data[:mapping] = []
      count = 0
      if @mapping_types.present?
        @mapping_types.each do |mapping_type|
          type_values = hotel.external_mappings.where('mapping_type=?', mapping_type)
          count += type_values.count
          data[:mapping] << {
            mapping_type: mapping_type.to_s,
            mapping_values: type_values.map do|mapping|
              {
                value: mapping.id.to_s,
                snt_value: mapping.value.to_s,
                external_value: mapping.external_value.to_s
              }
            end
          }
        end
        data[:total_count] = count
      end

      status = SUCCESS
    else
      errors << I18n.t(:missing_parameters, attribute: 'hotel_id ')
    end

    respond_to do |format|
      format.html { render partial: 'admin/hotels/external_mappings', locals: { data: data,  errors: errors } }
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end

  def new_mappings
    data, errors, status = {}, [], FAILURE

    hotel = Hotel.find(params[:hotel_id])

    if @mapping_types.present?
      data[:mapping_type] = get_mapping_type_array(@mapping_types,hotel)
      status = SUCCESS
    end

    respond_to do |format|
      format.html { render partial: 'admin/hotels/add_new_external_mapping', locals: { data: data,  errors: errors } }
      format.json { render json: { 'status' => 'success', 'data' => data, 'errors' => errors } }
    end
  end

  def save_mapping
    data, errors, status = {}, [], FAILURE
    hotel = Hotel.find(params[:hotel_id])

    if params[:mapping_value].present? && params[:snt_value].present? && params[:external_value].present?
      mapping_type = params[:mapping_value]
      snt_value = params[:snt_value]
    else
      errors << I18n.t(:missing_parameters, attribute: 'Mapping Type or SNT Value or External Value')
    end

    unless snt_value.nil?
      begin
        if params[:value].present?
          mapping = ExternalMapping.find(params[:value])
          mapping.update_attributes!(:value=>snt_value ,:external_value=>params[:external_value], :mapping_type=>mapping_type)
        else
          mapping = ExternalMapping.create!(:value => snt_value, :external_value => params[:external_value], :hotel_id => hotel.id, :mapping_type => mapping_type, :pms_type_id => hotel.pms_type.andand.id)
        end

        data[:value] = mapping.id.to_s if mapping.present?
        status = SUCCESS

      rescue ActiveRecord::RecordInvalid => ex
        errors << I18n.t(:invalid_parameters, attribute: ex.message)
      end
    end

    render json: { status: status, data: data, errors: errors }
  end

  def edit_mapping
    data, errors, status = {}, [], FAILURE
    mapping = ExternalMapping.find(params[:id])

    if mapping
      if @mapping_types.present?
        data[:mapping_type] = get_mapping_type_array(@mapping_types, mapping.hotel)
        data[:selected_mapping_type] = mapping.mapping_type
        data[:selected_snt_value] = mapping.value
        data[:external_value] = mapping.external_value
        data[:value] = params[:id]
      end
      status = SUCCESS
    end

    respond_to do |format|
      format.html { render partial: 'admin/hotels/edit_external_mapping', locals: { data: data,  errors: errors } }
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end

  def delete_mapping
    ExternalMapping.find(params[:id]).destroy
    response =  { 'status' => SUCCESS, 'data' => {}, 'errors' => [] }
    render json: response
  end

  private

  def get_mapping_type_array(mapping_types, hotel)
    mapped_array = []

    mapping_types.each do |mapping_type|
      values = nil

      if mapping_type == Setting.mapping_types[:address_type] || mapping_type == Setting.mapping_types[:email_type] || mapping_type == Setting.mapping_types[:phone_type]
        values = Ref::ContactLabel.all
      elsif mapping_type == Setting.mapping_types[:preference_type]
        values = hotel.feature_types
      elsif mapping_type == Setting.mapping_types[:preference_value]
        values = hotel.features
      elsif mapping_type == Setting.mapping_types[:membership_class]
        values = Ref::MembershipClass.all
      elsif mapping_type == Setting.mapping_types[:membership_type]
        values = hotel.membership_types
      elsif mapping_type == Setting.mapping_types[:credit_card_type]
        # For credit card type, also include the non-CC payment types
        values = Ref::CreditCardType.all + PaymentType.non_credit_card(hotel)
      elsif mapping_type == Setting.mapping_types[:vip_exclusion]
        values = [value: Setting.exclude_vip_value]
      end

      unless values.nil?
        mapped_array << {
          name: mapping_type,
          sntvalues: values.map { |value| { name: value[:value] } }
        }
      end
    end

    mapped_array
  end
end
