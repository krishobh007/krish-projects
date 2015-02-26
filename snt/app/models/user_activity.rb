class UserActivity < ActiveRecord::Base
  attr_accessible :user_id, :hotel_id, :application, :action_type, :activity_status, :message,
                  :user_ip_address, :activity_date_time, :user_type, :associated_activity_id, :associated_activity_type

  has_enumerated :action_type, class_name: 'Ref::ActionType'
  has_enumerated :application, class_name: 'Ref::Application'

  belongs_to :associated_activity, polymorphic: true
  belongs_to :hotel

  scope :search, lambda { |filter, hotel_zone|
    between_dates(filter[:from_date], filter[:to_date], hotel_zone).for_user(filter[:user_ids]).sort_by(filter[:sort_field], filter[:sort_dir] ,)
  }

  scope :join_users, lambda {
    joins(:user)
  }

  scope :join_staff, lambda {
    joins('LEFT OUTER JOIN staff_details on staff_details.user_id = user_activities.associated_activity_id AND associated_activity_type = "User"')
  }

  # If from and/or to dates are provided, filter by them
  scope :between_dates, proc { |from_date, to_date, hotel_zone|
    begin_time = getDatetime(from_date.to_s ,'00:00'.to_s, hotel_zone ).utc
    end_time = getDatetime(to_date.to_s ,'23:59'.to_s, hotel_zone ).utc
    result = scoped
    result = result.where('? <= user_activities.created_at', begin_time) if from_date.present?
    result = result.where('user_activities.created_at < ?', end_time) if to_date.present?
   result
  }

  # If staff ids are provided, add condition to filter by it
  scope :for_user, proc { |user_ids|
    result = scoped

    result = result
              .joins('LEFT OUTER JOIN users ON users.id = associated_activity_id AND associated_activity_type = "User"')
              .joins('LEFT OUTER JOIN guest_details ON guest_details.id = associated_activity_id AND associated_activity_type = "GuestDetail"')

    result = result.where('associated_activity_id in (:user_ids)', user_ids: user_ids) if user_ids.present?        
    result
  }

  # Sort by field and direction
  scope :sort_by, lambda { |sort_field, sort_dir|
    sort_order = sort_dir ? 'asc' : 'desc'

    result = scoped

    case sort_field
    when 'USER'
      result.join_staff.order("staff_details.first_name #{sort_order} , guest_details.first_name #{sort_order}")
    else
      result.order("user_activities.created_at #{sort_order}")
    end
  }
    def self.getDatetime(date, time, tz_info)
      ActiveSupport::TimeZone[tz_info].parse(date.to_s + ' ' + time.to_s)
    end
end
