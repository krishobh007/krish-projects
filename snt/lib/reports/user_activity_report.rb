# Return the login logout details
class UserActivityReport < ReportGenerator
  def process
    # Construct the initial query for user_activities
    user_activities = @hotel.user_activities.search(@filter, @hotel.tz_info).page(@filter[:page]).per(@filter[:per_page])
    
    # # Paginate the dates
    dates = Kaminari.paginate_array(report_date_array(@filter)).page(@filter[:page]).per(@filter[:per_page])
    @filter[:from_date], @filter[:to_date] = [dates.first, dates.last].sort
    
    if @filter[:zest]
      user_activities = user_activities.with_application(:ZEST)
    elsif @filter[:rover]
      user_activities = user_activities.with_application(:ROVER)
    elsif @filter[:zest_web]
      user_activities = user_activities.with_application(:WEB)
    end
    
    if @filter[:zest] && @filter[:rover]
      user_activities = user_activities.with_application(:ROVER, :ZEST)
    end
    
    if @filter[:zest] && @filter[:zest_web]
      user_activities = user_activities.with_application(:ZEST, :WEB)
    end
    
    if @filter[:rover] && @filter[:zest_web]
      user_activities = user_activities.with_application(:ROVER, :WEB)
    end

    if @filter[:zest] && @filter[:rover] && @filter[:zest_web]
      user_activities = user_activities.with_application(:ROVER, :ZEST, :WEB)
    end

    # Sort by user_activities date if sort field is DATE
    output_report(user_activities)
  end

  def construct_results(user_activities)
    user_activities.map do |user_activity|
      if user_activity.associated_activity_type == 'User' && user_activity.application_id == :ROVER
        user_name = user_activity.associated_activity.staff_detail.andand.full_name
      elsif user_activity.associated_activity_type == 'User' && user_activity.application_id == :ZEST
        user_name = user_activity.associated_activity.andand.login
      else
        user_name = user_activity.associated_activity.andand.full_name
      end
      result = {
        date: user_activity.created_at.in_time_zone(@hotel.tz_info).strftime('%Y-%m-%d, %I:%M %p') || '',
        user_name: user_name || '',
        ip_address: user_activity.user_ip_address || '',
        action_type: user_activity.action_type.andand.value || '',
        application: user_activity.application.andand.value || '',
        hotel: user_activity.hotel.name || '',
        }
    end    
  end

  def output_report(user_activities)
    { headers: [],  sub_headers: [:user_activity_time, :user_activity_type, :user_activity_user, :user_activity_application, :user_activity_ip], results: construct_results(user_activities), totals: [], total_count: user_activities.total_count }
  end
end
