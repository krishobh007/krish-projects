# Provides the admin APIs for managing the policies
class Api::PoliciesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :retrieve, only: [:show, :update, :destroy]

  # Lists the policies
  def index
    @policies = current_hotel.policies.page(params[:page]).per(params[:per_page]).order(:name)
    @policies = @policies.where(policy_type_id: Ref::PolicyType[params[:policy_type]]) if params[:policy_type]
  end

  # Shows the details about a policy
  def show
  end

  # Create a new policy.
  def create
    @policy = Policy.new(policy_params)
    @policy.save || render_invalid
  end

  # Update an existing policy
  def update
    @policy.update_attributes(policy_params) || render_invalid
  end

  # Destroys a policy
  def destroy
    @policy.destroy || render_invalid
  end

  private

  # Retrieve the selected policy
  def retrieve
    @policy = Policy.find(params[:id])
    fail I18n.t(:access_denied) unless @policy.hotel_id == current_hotel.id
  end

  # Render the validation errors
  def render_invalid
    render(json: @policy.errors.full_messages, status: :unprocessable_entity)
  end

  def policy_params
    {
      name: params[:name],
      description: params[:description],
      amount: params[:amount],
      amount_type: params[:amount_type],
      post_type_id: params[:post_type_id],
      apply_to_all_bookings: params[:apply_to_all_bookings],
      advance_days: params[:advance_days],
      advance_time: params[:advance_time].present? ? ActiveSupport::TimeZone[current_hotel.tz_info].parse(params[:advance_time]) : nil,
      policy_type: params[:policy_type],
      hotel_id: current_hotel.id,
      charge_code_id: params[:charge_code_id].present? ? params[:charge_code_id] : nil,
      allow_deposit_edit: params[:allow_deposit_edit]
    }
  end
end
