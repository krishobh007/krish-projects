class Api::ReportsController < ApplicationController
  respond_to :json
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :retrieve, only: [:show, :submit]

  # List the reports
  def index
    late_checkout_on = current_hotel.settings.late_checkout_is_on
    upsell_on = current_hotel.settings.upsell_is_on

    if late_checkout_on && upsell_on
      @reports = Report.page(params[:page]).per(params[:per_page]).order(:title)

    elsif late_checkout_on && !upsell_on
      @reports = Report.exclude_upsell.page(params[:page]).per(params[:per_page]).order(:title)

    elsif !late_checkout_on && upsell_on
      @reports = Report.exclude_late_checkout.page(params[:page]).per(params[:per_page]).order(:title)

    elsif !late_checkout_on && !upsell_on
      @reports = Report.exclude_late_checkout.exclude_upsell.page(params[:page]).per(params[:per_page]).order(:title)
    end
    @reports.delete_if { |report| report.title == 'Booking Source & Market Report' } if current_hotel.is_third_party_pms_configured?
  end

  # Show the report details
  def show
  end

  # Execute the report and return the results
  def submit
    @data = @report.process(current_hotel, filter)  
  end

  # CICO-12639
  def search_by_company_agent_group
    # Fetch all accounts - Comapny/Travel Agent Cards
    @accounts = current_hotel.hotel_chain.accounts.find_account(params)
    @accounts_array =  @accounts.map { |account| { id: 'account_'+account.id.to_s,
                                                   name: account.account_name,
                                                   type: account.account_type.value.to_s
                                                 }
                                      }
    # Fetch all groups
    @groups = current_hotel.groups.where('groups.name LIKE ?',"%#{params[:query]}%")
    @groups_array = @groups.map { |group| {
                                            id: 'group_'+group.id.to_s,
                                            name: group.name,
                                            type: 'GROUP'}
                                }
    # Get all results in a single array
    @search_array = @accounts_array + @groups_array
  end


  private

  # Retrieve the report
  def retrieve
    @report = Report.find(params[:id])
  end
 
  # Report Filter
  def filter
    {
      page: params[:page],
      per_page: params[:per_page],
      sort_field: params[:sort_field],
      sort_dir: params[:sort_dir] == 'true',
      user_ids: params[:user_ids],
      checked_in: params.key?(:checked_in) ? params[:checked_in] == 'true' : true,
      checked_out: params.key?(:checked_out) ? params[:checked_out] == 'true' : true,
      from_date: params.key?(:from_date) ? Date.parse(params[:from_date]) : nil,
      to_date: params.key?(:to_date) ? Date.parse(params[:to_date]) : nil,
      vip_only: params.key?(:vip_only) ? params[:vip_only] == 'true' : false,
      include_notes: params.key?(:include_notes) ? params[:include_notes] == 'true' : false,
      include_canceled: params.key?(:include_canceled) ? params[:include_canceled] == 'true' : false,
      include_no_show: params.key?(:include_no_show) ? params[:include_no_show] == 'true' : false,
      cancel_from_date: params.key?(:cancel_from_date) ? Date.parse(params[:cancel_from_date]) : nil,
      cancel_to_date: params.key?(:cancel_to_date) ? Date.parse(params[:cancel_to_date]) : nil,
      from_time: params[:from_time],
      to_time: params[:to_time],
      show_guests: params.key?(:show_guests) ? params[:show_guests] == 'true' : true,
      include_source: params.key?(:include_source) ? params[:include_source] == 'true' : false,
      include_market: params.key?(:include_market) ? params[:include_market] == 'true' : false,
      arrival_from_date: params.key?(:arrival_from_date) ? Date.parse(params[:arrival_from_date]) : nil,
      arrival_to_date: params.key?(:arrival_to_date) ? Date.parse(params[:arrival_to_date]) : nil,
      login: params.key?(:login) ? params[:login] == 'true' : true,
      logout: params.key?(:logout) ? params[:logout] == 'true' : true,
      zest: params.key?(:zest) ? params[:zest] == 'true' : true,
      rover: params.key?(:rover) ? params[:rover] == 'true' : true,
      zest_web: params.key?(:zest_web) ? params[:zest_web] == 'true' : true,
      deposit_from_date: params[:deposit_from_date],
      deposit_to_date: params[:deposit_to_date],
      deposit_paid: params.key?(:deposit_paid) ? params[:deposit_paid] == 'true' : true,
      deposit_due: params.key?(:deposit_due) ? params[:deposit_due] == 'true' : true,
      deposit_past: params.key?(:deposit_past) ? params[:deposit_past] == 'true' : true,
      include_companycard_ta_group: params.key?(:include_companycard_ta_group) ? params[:include_companycard_ta_group] : false,
      include_guarantee_type: params.key?(:include_guarantee_type) ? params[:include_guarantee_type] : false
      
      
    }
  end
end
