class Admin::ChargeCodesController < ApplicationController
  before_filter :check_session

  def import
    status, errors, data = SUCCESS, [], {}

    unless current_hotel.sync_external_charge_code
      status = FAILURE
      errors << I18n.t(:external_pms_failed)
    end

    render json: { status: status, errors: errors, data: data }
  end

  def list_charge_codes
    data, errors , details, status = {}, [], [], FAILURE
    data[:is_connected_to_pms] = current_hotel.pms_type.present? ? 'true' : 'false'
    
    page_number = params[:page] || 1
    per_page    = params[:per_page] || 10
    query       = params[:query] || ""
    sort_by     = params[:sort_field] || 'charge_code'
    if sort_by != 'charge_code'
      if sort_by == 'charge_group'
        sort_by = 'charge_groups.charge_group'
      else
        sort_by = 'charge_code'
      end
    end
    sort_direction = params[:sort_dir].nil? ? 'ASC' : (params[:sort_dir] == 'true' ? 'ASC' : 'DESC')
    order_query = "#{sort_by} #{sort_direction}"
       
    charge_codes = current_hotel.charge_codes.includes(:charge_groups)
                    .where("charge_codes.charge_code LIKE ? OR charge_codes.description LIKE ?", "%#{query}%", "%#{query}%")
                    .order(order_query)
    
    total_count = charge_codes.count
    data[:total_count] = total_count
    
    data[:charge_codes] = charge_codes.page(page_number).per(per_page).map do|charge_code|
      map_charge_code_details(charge_code)
    end
    
    status = SUCCESS
    respond_to do |format|
      format.html { render partial: 'admin/charge_codes/charge_codes_list', locals: { data: data,  errors: errors } }
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end

  def charge_codes_minimal_list
    data = []
    current_hotel.charge_codes.include_charge.each do |code|
      data << {value: code.id.to_s, charge_code: code.charge_code, description: code.description} 
    end
    render json: data
  end

  def new_charge_code
    data, errors , details, status = {}, [], [], FAILURE
    data[:charge_groups] = get_charge_group_items(current_hotel)
    data[:charge_code_types] = get_charge_code_types
    data[:tax_codes] =  get_tax_codes
    data[:fees_codes] = get_fees_codes
    data[:amount_types] = get_amount_types
    data[:post_types] = get_post_types
    data[:payment_types] = payment_types
    status = SUCCESS
    respond_to do |format|
      format.html { render partial: 'admin/charge_codes/add_new_charge_code', locals: { data: data,  errors: errors } }
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end

  def save_charge_code
    data, errors , details, status = {}, [], [], FAILURE

    begin
      charge_group = current_hotel.charge_groups.find(params[:selected_charge_group]) if params[:selected_charge_group].present?

      if params[:id].present?
        charge_code =   current_hotel.charge_codes.find(params[:id])
        charge_code.attributes = charge_code_params
      else
        charge_code = current_hotel.charge_codes.new(charge_code_params)
      end
      charge_code.charge_groups = []
      charge_code.charge_groups << charge_group if charge_group
      charge_code.charge_code_generates.tax(current_hotel).destroy_all

      if params[:selected_payment_type].present?
        payment_type = params[:is_cc_type] ? Ref::CreditCardType.find(params[:selected_payment_type]) : PaymentType.find(params[:selected_payment_type])
        payment_type.charge_codes << charge_code
      end
      charge_code.save!

      if params[:linked_charge_codes].present?
        params[:linked_charge_codes].each do |linked_charge_code|
          # Insert into charge_code_generates table
          charge_code_generate = charge_code.charge_code_generates.create!(
            generate_charge_code_id: linked_charge_code[:charge_code_id],
            is_inclusive: linked_charge_code[:is_inclusive] )
          if linked_charge_code[:calculation_rules].present?
            linked_charge_code[:calculation_rules].each do |rule_charge_code|
              # Insert into tax calculation rules table
              linked_charge_code_generate = charge_code.charge_code_generates.find_by_generate_charge_code_id(rule_charge_code)
              charge_code_generate.tax_calculation_rules.create(
                linked_charge_code_generate_id: linked_charge_code_generate.id
              )
            end
          end
        end
      end
      if params[:selected_fees_code].present?
        fees = charge_code.charge_code_generates.fees(current_hotel).first
        if fees
          fees.update_attribute(:generate_charge_code_id, params[:selected_fees_code])
        else
          charge_code.charge_code_generates.create!(
            generate_charge_code_id: params[:selected_fees_code])
        end
      else
        charge_code.charge_code_generates.fees(current_hotel).destroy_all
      end
      data = map_charge_code_details(charge_code)
      status = SUCCESS
    rescue ActiveRecord::RecordInvalid => ex
      errors = charge_code.errors.full_messages
    end

    render json: { status: status, data: data, errors: errors }
  end

  def edit_charge_code
    data, errors , details, status = {}, [], [], FAILURE
    charge_code = current_hotel.charge_codes.find(params[:id])
    amount_sign = (charge_code.amount && charge_code.amount > 0) ? "+" : "-"

    data = {
      id: charge_code.id.to_s,
      code: charge_code.charge_code,
      description: charge_code.description,
      selected_charge_group: charge_code.charge_groups.present? ? charge_code.charge_groups.first.id.to_s : '',
      selected_charge_code_type: charge_code.charge_code_type.id.to_s,
      selected_amount_symbol: charge_code.amount_symbol,
      selected_amount_sign: amount_sign,
      amount: charge_code.amount.andand.abs,
      minimum_amount_for_fees: charge_code.minimum_amount_for_fees,
      selected_amount_type: charge_code.amount_type_id,
      selected_post_type: charge_code.post_type_id
    }

    data[:selected_payment_type] = charge_code.associated_payment.andand.id if charge_code.charge_code_type === :PAYMENT

    data[:is_cc_type] = charge_code.associated_payment_type == "Ref::CreditCardType" if charge_code.charge_code_type === :PAYMENT
    data[:charge_groups] = get_charge_group_items(current_hotel)
    data[:charge_code_types] = get_charge_code_types
    data[:amount_types] = get_amount_types
    data[:post_types] = get_post_types
    data[:tax_codes] = get_tax_codes
    data[:fees_codes] = get_fees_codes
    # Only one fees code can be linked to a charge code
    # CICO-9457
    data[:selected_fees_code] = charge_code.charge_code_generates.fees(current_hotel).first.andand.generate_charge_code_id
    data[:payment_types] = payment_types(charge_code.associated_payment)
    data[:linked_charge_codes] = get_linked_charge_codes(charge_code)
    status = SUCCESS

    respond_to do |format|
      format.html { render partial: 'admin/charge_codes/edit_charge_code', locals: { data: data,  errors: errors } }
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end

  def delete_charge_code
    data, errors , details, status = {}, [], [], FAILURE

    charge_code = current_hotel.charge_codes.find(params[:id]) if current_hotel

    if charge_code
      fin_txns = FinancialTransaction.where('charge_code_id = ?', charge_code.id)
      if fin_txns.present?
        errors <<  I18n.t(:charge_code_in_use)
      elsif charge_code.items.present?
        errors <<  I18n.t(:charge_code_in_use)
      else
        charge_code.charge_groups = []
        ChargeCodeGenerate.where('charge_code_id =? OR generate_charge_code_id = ?', charge_code.id, charge_code).destroy_all
        charge_code.delete
        status = SUCCESS
      end
    end

    render json: { status: status, data: data, errors: errors }
  end

  def delete_tax
    charge_code = current_hotel.charge_codes.find(params[:id])
    charge_code_generate = charge_code.charge_code_generates.find_by_generate_charge_code_id(params[:charge_code_id])
    charge_code_generate.destroy
  end

  private

  def get_charge_group_items(current_hotel)
    charge_groups = []
    charge_groups  = current_hotel.charge_groups.map do|charge_group|
      {
        value: charge_group.id.to_s,
        name: charge_group.charge_group
      }

    end
    charge_groups
  end

  def get_charge_code_types
    charge_code_types = []
    charge_code_types = Ref::ChargeCodeType.all.map do|chage_code_type|
      {
        value: chage_code_type.id.to_s,
        name: chage_code_type.to_s,
        is_tax: (chage_code_type == Ref::ChargeCodeType[:TAX]) ? 'true' : 'false'
      }
    end
    charge_code_types
  end

  def get_amount_types
    amount_types = []
    amount_types = Ref::AmountType.all.map do|amount_type|
      {
        value: amount_type.id.to_s,
        name: amount_type.to_s
      }
    end
    amount_types
  end

  def get_post_types
    post_types = []
    post_types = Ref::PostType.all.map do|post_type|
      {
        value: post_type.id.to_s,
        name: post_type.to_s
      }
    end
    post_types
  end

  def get_tax_codes
    tax_codes = []
    tax_codes = current_hotel.charge_codes.tax.map do|charge_code|
      {
        value: charge_code.id.to_s,
        name: charge_code.charge_code,
        description: charge_code.description
      }
    end
    tax_codes
  end

  def get_fees_codes
    fees_codes = []
    fees_codes = current_hotel.charge_codes.fees.map do|charge_code|
      {
        value: charge_code.id.to_s,
        name: charge_code.charge_code,
        description: charge_code.description
      }
    end
    fees_codes
  end

  def get_linked_charge_codes(charge_code)
    linked_charge_codes = []
    charge_code.charge_code_generates.tax(current_hotel).map do |charge_code_generate|
      {
        charge_code_id: charge_code_generate.generate_charge_code_id.to_s,
        is_inclusive: charge_code_generate.is_inclusive,
        calculation_rules: charge_code_generate.tax_calculation_rule_charge_codes.map {|x| x.id}
      }
    end
  end

  def map_charge_code_details(charge_code)
    charge_code_generates = charge_code.charge_code_generates

    has_inclusive_generates = charge_code_generates.select { |generate| generate.is_inclusive }.present?
    has_exclusive_generates = charge_code_generates.select { |generate| !generate.is_inclusive }.present?

    if has_inclusive_generates && has_exclusive_generates
      inclusive_or_exclusive = 'Multiple'
    elsif has_exclusive_generates
      inclusive_or_exclusive = 'Exclusive'
    elsif has_inclusive_generates
      inclusive_or_exclusive = 'Inclusive'
    else
      inclusive_or_exclusive = nil
    end

    child_charge_codes = charge_code_generates.map { |charge_code_generate| charge_code_generate.generate_charge_code.charge_code }

    {
      value: charge_code.id.to_s,
      charge_code: charge_code.charge_code,
      description: charge_code.description,
      charge_group: charge_code.charge_groups.present? ? charge_code.charge_groups.first.charge_group : '',
      charge_code_type: charge_code.charge_code_type.to_s,
      link_with: child_charge_codes,
      inclusive_or_exclusive: inclusive_or_exclusive
    }
  end

  def payment_types (linked_payment_type = nil)
    linked_type = []
    non_cc_types  = current_hotel.payment_types.where('active = ?', true).all.map do |payment_type|
      {
        value: payment_type.id,
        name: payment_type.value,
        description: payment_type.description,
        is_cc_type: false
      } unless payment_type.charge_codes.where(hotel_id: current_hotel.id).present?
    end
    cc_types = Ref::CreditCardType.activated(current_hotel).all.map do |cc_payment_type|
      {
        value: cc_payment_type.id,
        name: cc_payment_type.value,
        description: cc_payment_type.description,
        is_cc_type: true
      } unless cc_payment_type.charge_codes.where(hotel_id: current_hotel.id).present?
    end
    linked_type << {
      value: linked_payment_type.id,
      name: linked_payment_type.value,
      description: linked_payment_type.description,
      is_cc_type: !PaymentType.non_credit_card(current_hotel).include?(linked_payment_type)
    } if linked_payment_type
    non_cc_types.compact + cc_types.compact + linked_type.compact
  end


  private

  def charge_code_params
    if params[:selected_charge_code_type]
      charge_code_type = Ref::ChargeCodeType.find(params[:selected_charge_code_type])
    end
    if params[:amount]
      amount = params[:selected_amount_sign] + params[:amount]
    end
    {
      charge_code: params[:code],
      charge_code_type: charge_code_type.present? ? charge_code_type.id : nil,
      description: params[:description],
      post_type_id: params[:selected_post_type],
      amount_type_id: params[:selected_amount_type],
      amount: amount.to_f,
      amount_symbol: params[:selected_amount_symbol],
      minimum_amount_for_fees: params[:minimum_amount_for_fees]
    }
  end
end
