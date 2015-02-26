class Campaign < ActiveRecord::Base
  attr_accessible :name, :body, :subject, :call_to_action_label, :call_to_action_target,
                  :alert_ios7, :alert_ios8, :is_recurring, :date_to_send, :time_to_send,
                  :is_scheduled, :recurrence_end_date, :last_sent_at, :status, :audience_type_id,
                  :campaign_type_id, :hotel_id, :day_of_week, :user_name

  belongs_to :hotel

  has_one :header_image, class_name: 'Image', as: :image_attachable
  
  has_enumerated :audience_type, class_name: 'Ref::CampaignAudienceType'
  has_enumerated :campaign_type, class_name: 'Ref::CampaignType'
  has_one :campaign_notification, class_name: 'NotificationDetail', as: :notification
  has_many :campaigns_recepients
  has_many :guest_details, through: :campaigns_recepients
  
  validates :name, :audience_type_id, :subject, :body, presence: true
  validates :alert_ios7, :alert_ios8, presence: true
  
  validate :recurring_campaign

  # Sort by the selected field and direction
  scope :sort_by, lambda { |sort_field, sort_dir|
    sort_order = sort_dir != 'false' ? 'asc' : 'desc'

    results = scoped

    case sort_field
    when 'name'
      results = results.order("campaigns.name #{sort_order}")
    when 'audience_type'
      results = results
               .joins("INNER JOIN ref_campaign_audience_types ON ref_campaign_audience_types.id=campaigns.audience_type_id")
               .order("ref_campaign_audience_types.value #{sort_order}")
    when 'status'
      results = results.order("campaigns.status #{sort_order}")
    when 'last_updated_date'
      results = results.order("campaigns.updated_at #{sort_order}")
    when 'delivery'
      results = results.order("campaigns.is_recurring #{sort_order}")
    end
    results.order("campaigns.id #{sort_order}")

  }


  def set_header_image(base64_data)
    base64_data = base64_data.split('base64,')[1]
    file_name = "logo#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(Base64.decode64(base64_data))
    end
    header_image_file = File.open(image_path)
    self.header_image = Image.new
    self.header_image.image = header_image_file
    self.header_image.save!
    File.delete(image_path)
  end

  def recurring_campaign
  	if is_recurring
      validates_presence_of :date_to_send, :time_to_send, :day_of_week, message: ' missing'
    end
  end

  def is_not_completed
    if is_recurring
      !self.recurrence_end_date  || (self.recurrence_end_date && self.recurrence_end_date >= self.hotel.active_business_date)
    else
      self.date_to_send > self.hotel.active_business_date
    end  
  end

end
