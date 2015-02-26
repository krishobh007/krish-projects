class Api::CampaignsController < ApplicationController
  before_filter :check_session

  def index
    @campaigns = current_hotel.campaigns.page(params[:page]).per(params[:per_page]).sort_by(params[:sort_field], params[:sort_dir])
  end

  def show
    @campaign = current_hotel.campaigns.find(params[:id])
  end

  def create
    begin
      @campaign = current_hotel.campaigns.create!(campaign_params)
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
      return
    end
    if params[:header_image].present?
      @campaign.set_header_image(params[:header_image])
    end
    if params[:specific_users].present?
      reservations = current_hotel.reservations.joins(guest_details: :emails).where('additional_contacts.value = ?', params[:specific_users])
      @campaign.campaigns_recepients.create(:campaign_id => @campaign.id, :guest_detail_id => reservations.first.guest_details.first.id) if reservations.present?
    end
  end

  def update
    @campaign = current_hotel.campaigns.find(params[:id])
    @campaign.update_attributes(campaign_params)
    if @campaign.is_recurring && (@campaign.recurrence_end_date.present? && @campaign.recurrence_end_date <= @campaign.hotel.active_business_date )
      @campaign.update_attributes(:status => :COMPLETED)
    end
  end

  def destroy
    @campaign = current_hotel.campaigns.find(params[:id])
    @campaign.campaign_notification.destroy
    @campaign.destroy
  end

  def start_campaign
    @campaign = current_hotel.campaigns.find(params[:id])
    if @campaign.is_recurring
      @campaign.update_attributes(:status => :ACTIVE)
    else
      Resque.enqueue(CampaignOneTimeNotifier, @campaign.id)
      @campaign.update_attributes(:status => :ACTIVE)
    end
  end
  
  def alert_length
    
  end
  
  private

  def campaign_params
    { 
      name: params[:name],
      subject: params[:subject],
      body: params[:body],
      call_to_action_label: params[:call_to_action_label],
      call_to_action_target: params[:call_to_action_target],
      alert_ios7: params[:alert_ios7],
      alert_ios8: params[:alert_ios8],
      is_recurring: params[:is_recurring],  # flag to check ONE_TIME or Recurring
      date_to_send: current_hotel.active_business_date,
      day_of_week: params[:day_of_week],
      time_to_send: params[:is_recurring] ? params[:time_to_send] : Time.now,
      recurrence_end_date: params[:recurrence_end_date] ? Date.strptime(params[:recurrence_end_date], '%Y-%m-%d') : '',
      audience_type_id: params[:audience_type] ? Ref::CampaignAudienceType[params[:audience_type]].id : '',
      status: params[:status] ? params[:status] : :DRAFT,
      campaign_type_id: Ref::CampaignType[:MESSAGE].id
    }
  end
end
