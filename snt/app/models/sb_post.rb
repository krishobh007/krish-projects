class SbPost < ActiveRecord::Base
  attr_accessible :hotel_id, :user_id, :author_ip, :comment_count, :body_html, :group_id, :ad_id, :body, :author_name, :author_email
  belongs_to :hotel, autosave: false, validate: false
  belongs_to :user
  belongs_to :hotel, class_name: 'Hotel'
  has_many :comments, class_name: 'Comment', as: :commentable
  # acts_as_commentable
  belongs_to :group, counter_cache: false, autosave: false, validate: false

  validates :user_id, :hotel_id, :body, presence: true

  scope :asc, -> { order('p.created_at ASC') }
  scope :desc, -> { order('p.created_at DESC') }

  scope :recent_chain_posts, proc { |chain_id|
   with_query_options.joins('inner join hotels on sb_posts.hotel_id = hotels.id').where("ad_id is null && hotels.hotel_chain_id = #{chain_id}").page(0)
 }

  scope :recent_hotel_posts, proc { |hotel_id|
    with_query_options.joins('inner join hotels on sb_posts.hotel_id = hotels.id').where("ad_id is null && hotels.id = #{hotel_id}").page(0)
  }

  scope :posts_with_begin_tiime , proc{|hotel_id, created_at, begin_time, limit|
      where('p.hotel_id = ? AND p.created_at < ? AND p.created_at > ?', hotel_id, created_at, begin_time.utc.to_formatted_s(:db)).desc.limit(limit)
    }

  scope :posts_without_begin_tiime , proc{|hotel_id, created_at, limit|
    where('p.hotel_id = ?', hotel_id).desc.limit(limit)
  }

  def self.with_select
    select('p.*').from('sb_posts as p').joins('inner join users as u on u.id=p.user_id').joins('inner join users_roles as ur on ur.user_id=u.id')
  end

  def self.no_group(arg)
    SbPost.with_select.where('p.group_id is null')
  end

  def self.with_group(arg)
    SbPost.with_select.where('p.group_id = ? OR p.group_id is null', arg)
  end

  def self.group_only(arg)
    SbPost.with_select.where('p.group_id = ?', arg)
  end

  def reservation
    user.guest_detail.andand.current_reservation(hotel)
  end

  def as_json(options = {})
    opts = { only: [:id, :body, :body_html, :author_name] }.merge(options)
    result = super(opts)
    result = Hash[*result.map { |k, v| [k, v.to_s || ''] }.flatten]
    if result.nil?
      return false
    end
    unless user.nil?
      role = user.roles.first.id
      # result[:type] = @user_role == Setting.user_roles[:admin] ? "automated" : ((@user_role == Setting.user_roles[:staff]) ? "promotion" : "normal")
      # #Enforce automated message for check-in messages
      # if self.body.start_with?("Just checked")
        # result[:type] = "automated"
      # end
      result[:user] = user.as_json(except: [:api_key, :first_name, :last_name])
      # TODO : Replace this Hard coded data No fields in database
      result[:user][:in_group] = true.to_s

      if user.guest_detail.present?
        result[:user][:image_url] = user.guest_detail.avatar.url.to_s
        result[:user][:profession] = user.guest_detail.job_title.to_s
        result[:user][:first_name] = user.guest_detail.first_name.to_s
        result[:user][:last_name] = user.guest_detail.last_name.to_s
        result[:user][:works_at] = user.guest_detail.works_at.to_s
      else
        result[:user][:image_url] = ''
        result[:user][:profession] = ''
        result[:user][:first_name] = ''
        result[:user][:last_name] = ''
        result[:user][:works_at] = ''
      end

      result[:user][:lobby_status] = id % 2 == 0 ? true.to_s : false.to_s
      # End - hard coded data
      result[:user_role] = user.roles.first.name ? user.roles.first.name : ''
    end

    result[:group] = group ? group.name : ''
    result[:group_code] = group ? group.group_code : ''
    result[:comment_count] = comments.size.to_s
    result[:created_at] = ViewMappings::GuestZest::ReviewsMapping.map_created_at_time(created_at) # self.created_at.strftime("%Y-%m-%d %H:%M:%S")

    result
  end

  def since_today
    1.day.ago
  end

  def since_last_month
    30.days.ago
  end
end
