class Guest::CommentsController < ApplicationController
  before_filter :check_session

  respond_to :json

  def index
    # Get limit
    lim = params[:count].present? ? params[:count].to_i : Setting.comments_page_count
    to_date = params[:created_at] ? params[:created_at] : Time.now

    comments = Comment.desc.where('commentable_id = ? AND commentable_type = ? AND created_at <= ?', params[:commentable_id], params[:commentable_type], to_date).limit(lim)

    results = comments.map do |comment|
      user = comment.user

      {
        comment_id: comment.id.to_s,
        author_first_name:  user.guest_detail.present? ? user.guest_detail.first_name : '',
        author_last_name:  user.guest_detail.present? ? user.guest_detail.last_name : '',
        image_url:  user.guest_detail.present? ? user.guest_detail.avatar.url(:thumb) : '',
        message: comment.comment,
        user_role: user.roles.first.name
      }
    end

    render json: {
      status: 'success',
      data: results,
      errors: []
    }
  end

  # creates new comment
  # POST /api/hotels/:hotel_id/posts/:commentable_id/comments.json?api_key=werwrWETQQTE
  # POST /api/hotels/:hotel_id/events/:commentable_id/comments.json?api_key=werwrWETQQTE
  # {
  #  commentable_type: 'SbPost',
  #  title: one liner text
  #  comment: detailed text
  #  author_name: demo author
  # }
  def create
    comment = Comment.new(title: params[:title], comment: params[:message], author_name: params[:user_name], author_email: params[:user_email],
                          author_ip: request.remote_ip, commentable_id: params[:commentable_id], commentable_type: params[:commentable_type])

    comment.user_id = current_user.id
    if comment.save
      user = comment.user
      notification_detail = NotificationDetail.new
      notification_detail.create_notification_details(comment, user, comment.commentable.group_id)
      render json: {
        status: SUCCESS,
        data: {
          comment_id: comment.id.to_s,
          author_first_name: user.guest_detail.first_name,
          author_last_name: user.guest_detail.last_name,
          image_url: user.guest_detail.avatar.url(:thumb),
          message: comment.comment,
          user_role: user.roles.first.name
        },
        errors: []
      }
    else
      logger.debug comment.errors.full_messages
      render json: {
        status: FAILURE,
        data: {},
        errors: comment.errors.full_messages
      }
    end
  end
end
