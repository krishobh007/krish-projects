class Admin::HotelMembershipsController < ApplicationController
  before_filter :check_session
  def list_ffp
    status, errors, data = SUCCESS, [], {}
    hotel = current_hotel
    ffps = hotel.get_available_ffps

    data = {}
    data[:frequent_flyer_program] = ffps.map do |ffp|
      { id: ffp.id.to_s, airline: ffp.value, program_name: ffp.description, is_active: current_hotel.membership_types.pluck(:id).include?(ffp.id) }
    end if ffps
    respond_to do |format|
      format.html { render partial: 'ffp_list', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def list_hlp
    hotel = current_hotel
    hlps = hotel.get_available_hlps
    errors, status, data =  {}, SUCCESS, {}

    data[:hotel_loyalty_program] = hlps.map { |hlp| { value: hlp.id.to_s, name: hlp.description, is_active: current_hotel.membership_types.pluck(:id).include?(hlp.id).to_s } } if hlps
    respond_to do |format|
      format.html { render partial: 'hlp_list', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def add_hlp
    respond_to do |format|
      format.html { render partial: 'add_hlp' }
    end
  end

  def save_hlp
    status, data, errors = SUCCESS, {}, []

    membership_type = MembershipType.create(value: params[:code], description: params[:name], membership_class_id: Ref::MembershipClass[:HLP].id, property_type: 'Hotel', property_id: current_hotel.id)

    if !membership_type.errors.empty?
      status = FAILURE
      errors << membership_type.errors.full_messages
    else
      current_hotel.membership_types << membership_type
      data[:value] = membership_type.id
      data[:name] = membership_type.description
      data[:is_active] = "true"
      if params[:levels].present?
        params[:levels].each do | value|
         membership_level = MembershipLevel.create(membership_level: value[:name] , membership_type_id: membership_type.id)
         unless membership_level.errors.empty?
           status = FAILURE
           errors << membership_level.errors.full_messages
         end
       end
     end
    end

    render json: { 'status' => status, 'data' => data, 'errors' => errors }
  end

  def edit_hlp
    status, errors, data = SUCCESS, [], {}
    begin
      hotel = current_hotel
      membership_type = MembershipType.find(params[:id])
      membership_levels = membership_type.membership_levels.select([:membership_level, :id])

      data = { value: membership_type.id.to_s, name: membership_type.description, code: membership_type.value }
      data[:levels] = membership_levels.map { |level| { value: level.id.to_s , name: level.membership_level } } if membership_levels
    rescue ActiveRecord::RecordNotFound =>  e
      status, errors = FAILURE, e.message
    end

    respond_to do |format|
      format.html { render partial: 'edit_hlp', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def update_hlp
    status, data, errors = SUCCESS, {}, []
    membership_type = MembershipType.find(params[:value])
    membership_type.update_attributes(value: params[:code], description: params[:name])
    if !membership_type.errors.empty?
      status = FAILURE
      errors << membership_type.errors.full_messages
    else
      membership_level = membership_type.membership_levels.destroy_all
      if params[:levels].present?
        params[:levels].each do | value|
          membership_level = MembershipLevel.create(membership_level: value[:name] , membership_type_id: membership_type.id)
          unless membership_level.errors.empty?
            status = FAILURE
            errors << membership_level.errors.full_messages
          end
        end
      end
    end
    render json:  { 'status' => status, 'data' => data, 'errors' => errors }
 end

  def toggle_ffp_activation
    errors, status = [], SUCCESS
    begin
      ffp = current_hotel.get_available_ffps.find(params[:id])
      if params[:set_active] == false
        if current_hotel.membership_types.pluck(:id).include?(ffp.id)
          current_hotel.membership_types.delete(ffp)
        end
      else
        if current_hotel.membership_types.pluck(:id).include?(ffp.id)
          # To prevent data duplication in hotel_membership_types table
          errors, status = ['FFP already set to active mode'], FAILURE
        else
          current_hotel.membership_types << ffp
        end
      end
      rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end

  def toggle_hlp_activation
    errors, status = [], SUCCESS
    begin
      hlp = current_hotel.get_available_hlps.find(params[:value])
      if params[:set_active] == 'false'
        if current_hotel.membership_types.pluck(:id).include?(hlp.id)
          current_hotel.membership_types.delete(hlp)
        end
      else
        if current_hotel.membership_types.pluck(:id).include?(hlp.id)
          # To prevent data duplication in hotel_membership_types table
          errors, status = ['HLP already set to active mode'], FAILURE
        else
          current_hotel.membership_types << hlp
        end
      end
      rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end

# HLP methods END
end
