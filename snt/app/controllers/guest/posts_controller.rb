class Guest::PostsController < ApplicationController
  before_filter :check_session

  # Method to create posts based on group_id parameter received
  def create
    params = request.params
    hotel_id = params[:hotel_id]
    group_id = params[:group_id]
    params_post = ActiveSupport::JSON.decode(request.body)

    if params[:group_id] && params[:hotel_id]
      group = Group.find(group_id)
      params_post[:group_id] = group.id
    end
    params_post[:user_id] = current_user ? current_user.id : params[:user_id]
    params_post[:author_ip] = request.remote_ip # save the ip address for everyone
    params_post[:hotel_id] = hotel_id
    user = User.find_by_id(params_post[:user_id])

    post = SbPost.create(params_post)

    if !post.errors.empty?
      logger.debug post.errors.full_messages
      render json: { status: FAILURE, errors: post.errors.full_messages, data: [''] }
    else
      notification_detail = NotificationDetail.new
      notification_detail.create_notification_details(post, user, params_post[:group_id].present? ? params_post[:group_id] : nil)
      render json: { status: SUCCESS, data: post, errors: [''] }
    end
  end

 # Method to display all the posts for Social Lobby Application
  def index
    @user = current_user
    group_cond = 'with_group'
    logger.info ''
    if params[:group_id] && params[:hotel_id]
      group = Group.find(params[:group_id])
      group_cond = 'group_only'
      group_only = true
    end
    group_id = params[:group_id] ? group.id : nil
    @lim = Setting.posts_page_count unless @lim.nil?  # Set default value for pagination count from product_config

    unless params[:count].nil?
      @lim = params[:count].to_i # Set  value for pagination count from if specified in request parameter
    end

    if params[:created_at].nil?
      params[:created_at] = 1.minute.from_now.strftime('%Y-%m-%d %H:%M:%S')
    end

    if @user.guest_detail && @user.guest_detail.andand.current_reservation(params[:hotel_id])
      begin_time = @user.guest_detail.current_reservation(params[:hotel_id]).get_arr_time - @user.guest_detail.current_reservation(params[:hotel_id]).hotel.arr_grace_period.days
      end_time = @user.guest_detail.current_reservation(params[:hotel_id]).get_dep_time + @user.guest_detail.current_reservation(params[:hotel_id]).hotel.dep_grace_period.days
      created_time = Time.parse(params[:created_at] + 'UTC')
    end

    #  if begin_time #If this user has a valid reservation
        # if created_time > end_time #We dont have to bother if created_time is earlier than end_time
        #    params[:created_at] = end_time.utc.to_formatted_s(:db)
        # end
       #  @posts = SbPost.send(group_cond, "#{group_id}").posts_with_begin_tiime(params[:hotel_id],params[:created_at],begin_time,@limit)
     # else
    @posts = SbPost.send(group_cond, "#{group_id}").posts_without_begin_tiime(params[:hotel_id], params[:created_at], @lim)
     # end
    render json: {
      status: SUCCESS,
      errors: [''],
      data: @posts.uniq.map do |post|
        post
      end
    }
   end
end
