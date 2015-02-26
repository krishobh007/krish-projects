require 'date'

class User < ActiveRecord::Base
   include ApplicationHelper
  attr_accessible :role_id, :default_hotel_id,
                  :location, :role, :hotel_chain_id, :phone,
                  :email, :lastname, :login,
                  :password, :password_confirmation, :crypted_password,
                  :email_confirmation, :department_id, :staff_detail_attributes, :guest_detail_attributes,
                  :default_dashboard_id, :default_dashboard, :is_email_verified,
                  :last_password_update_at

  acts_as_authentic do |config|
    config.transition_from_crypto_providers = Sha1CryptoMethod
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.validations_scope = :hotel_chain_id
    config.merge_validates_length_of_password_field_options minimum: 8
    config.perishable_token_valid_for = 2.days
    config.validate :check_current_password, :if => :require_check_current_password?
    config.validate :password_repeated?, :if => :require_password_changed?
  end
  
  model_stamper

  attr_accessor :skip_default_hotel_validation, :password_presence_validation, :skip_default_dashboard_validation, :current_password
  
  serialize :old_passwords, Array
  after_validation :update_old_passwords
  
  # has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "50x50>" }, :path => ":class/:id/:attachment/:style/:filename", :default_url => :get_default_user_avatar

  has_one :guest_detail
  has_one :staff_detail

  has_and_belongs_to_many :notification_details, join_table: 'users_notification_details'
  has_many :users_notification_details
  has_many :notifying_device_details, class_name: 'NotificationDeviceDetail'

  belongs_to :hotel, class_name: 'Hotel', foreign_key: 'default_hotel_id', autosave: false, validate: false

  has_many :conversations, class_name: 'Conversation', foreign_key: 'creator_id'
  has_many :messages_recipients, class_name: 'MessagesRecipients', foreign_key: 'recipient_id'
  has_many :received_messages , through: :messages_recipients, class_name: 'Message', foreign_key: 'message_id'

  has_many :work_sheets

  has_and_belongs_to_many :hotels, uniq: true

  belongs_to :default_hotel, class_name: 'Hotel'
  belongs_to :hotel_chain, autosave: false, validate: false
  belongs_to :department

  has_many :pms_sessions
  has_many :reservation_notes
  has_many :cashier_periods
  has_many :modified_cashier_periods, class_name: 'CashierPeriod'
  has_and_belongs_to_many :admin_menu_options, join_table: "user_admin_bookmarks"
  has_many :pre_reservations

  has_one :notification_preference

  # has_enumerated :role
  has_and_belongs_to_many :roles, join_table: 'users_roles'

  has_enumerated :default_dashboard, class_name: 'Ref::Dashboard'

  has_many :financial_transactions, foreign_key: 'updater_id'
  
  has_many :user_activities, class_name: 'UserActivity', as: :associated_activity

  validates :email, presence: true
  validates :password, presence: true, if: :validate_password_presence?

  # Email must be unique per hotel chain (unless admin)
  validates :email, uniqueness: { scope: [:hotel_chain_id], case_sensitive: false }, unless: :admin?
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})\Z/ }

  validates :login, uniqueness: { scope: [:hotel_chain_id], case_sensitive: false }, unless: :admin?

  validates :default_hotel_id, presence: true, if: :default_hotel_required?
  validates :hotel_chain_id, presence: true, unless: :admin?
  validates :email, confirmation: true
  validates :password, format: { with: /^(?=.*[a-zA-Z])(?=.*[0-9]).{2,}$/,
                                 message: 'must be at least 8 characters and include at least one number and at least one letter' },
                       unless: ->(u) { u.password.nil? }

  validates :default_dashboard_id, presence: true, if: :default_dashboard_required?



  before_validation :sync_login_and_email, unless: :api_user?

  accepts_nested_attributes_for :guest_detail, :staff_detail

  scope :with_guest_role, -> { includes(:roles).where("roles.name = 'guest'") }
  scope :with_staff_role, -> { includes(:roles).where("roles.name not in ('guest', 'admin')") }
  scope :with_snt_admin_role, -> { includes(:roles).where("roles.name = 'admin'") }
  scope :with_hotel_admin_role, -> { includes(:roles).where("roles.name = 'hotel_admin'") }
  scope :not_snt_admin, -> { includes(:roles).where("roles.name <> 'admin'") }
  scope :with_maintenance_role, -> { includes(:roles).where("roles.name = 'floor_&_maintenance_staff'") }
  scope :with_cashier_role, -> { includes(:roles).where("roles.name IN ('hotel_admin', 'manager', 'front_office_staff', 'reservation_staff', 'accounting_staff')") }
  scope :active, -> { where('users.activated_at IS NOT NULL') }
  
  # Scope to find the employee list and HK details for a requested date
  scope :maid_list_on, proc { |request_date| joins(:staff_detail)
                 .joins('inner join work_sheets on  work_sheets.user_id = users.id')
                 .where("work_sheets.date = ?", request_date)
                 .select("staff_details.first_name as first_name,
                  staff_details.last_name as last_name, work_sheets.date as date,
                  work_sheets.work_type_id as work_type, work_sheets.id as work_sheet_id, users.id as employee_id") }
  
  # Scope to find the employee list and HK details for a requested date and work type             
  scope :maid_list_with_work_type_on, proc { |request_date, work_type_id| joins(:staff_detail)
                 .joins('inner join work_sheets on  work_sheets.user_id = users.id')
                 .where("work_sheets.date = ? AND work_sheets.work_type_id = ?", request_date, work_type_id)
                 .select("staff_details.first_name as first_name,
                  staff_details.last_name as last_name, work_sheets.date as date,
                  work_sheets.work_type_id as work_type, work_sheets.id as work_sheet_id, users.id as employee_id") }
  
  def update_old_passwords
    if self.errors.empty? and send("crypted_password_changed?")
      self.old_passwords ||= []
      self.old_passwords.unshift({:password => send("crypted_password"), :salt =>  send("password_salt") })
      self.old_passwords = self.old_passwords[0, 3]
    end
  end
  
  def require_password_changed?
    !new_record? && password_changed?
  end
  
  def require_check_current_password?
    !new_record? && !self.current_password.nil?
  end
  
  def password_repeated?
    return if self.password.blank?
    found = self.old_passwords.any? do |old_password|
      args = [self.password, old_password[:salt]].compact
      old_hash = BCrypt::Password.new(old_password[:password])
      old_hash == args.flatten.join
    end
    self.errors.add :password, "should be different from the password used last 3 times." if found
  end
  
  def check_current_password
    return if self.password.blank?
    current_hash = BCrypt::Password.new(self.crypted_password_was)
    args = [self.current_password, self.password_salt_was].compact
    unless current_hash == args.flatten.join
      self.errors.add :current_password, "do not match"
    end
  end
  
  def validate_password_presence?
    password_presence_validation
  end

  def as_json(opts = {})
    json = super(opts)
    Hash[*json.map { |k, v| [k, v.to_s || ''] }.flatten]
  end

  def first_login?
    login_count == 0
  end

  def admin?
    roles && roles.include?(Role.admin)
  end

  def self.find_by_login_or_email(string)
    first(conditions: ['LOWER(email) = ? OR LOWER(login) = ?', string.downcase, string.downcase])
  end

  def hotel_admin?
    roles && roles.include?(Role.hotel_admin)
  end

  def hotel_staff?
    roles && (roles.include?(Role.front_office_staff) || roles.include?(Role.manager) ||
                   roles.include?(Role.revenue_manager) ||
                   roles.include?(Role.find_by_name('floor_&_maintenance_staff')) || roles.include?(Role.find_by_name('floor_&_maintenance_manager'))||
                   roles.include?(Role.reservation_staff) || roles.include?(Role.accounting_staff) )
  end
  
  def floor_maintenance_staff?
    roles && roles.include?(Role.find_by_name('floor_&_maintenance_staff'))
  end

  def guest?
    roles && roles.include?(Role.guest)
  end

  def api_user?
    roles && roles.include?(Role.api_user)
  end

  # Set email to login if not set (and vice versa)
  def sync_login_and_email
    if !email.present?
      self.email = login
    elsif !login.present?
      self.login = email
    elsif email != login
      self.login = email
    end

    true
  end

  # Default hotel must be provided if not an admin or guest
  def default_hotel_required?
    !self.admin? && !self.api_user? && !self.guest? & !skip_default_hotel_validation
  end

  def default_dashboard_required?
    !self.admin? && !self.api_user? && !self.guest? & !skip_default_dashboard_validation
  end

  Paperclip.interpolates :hotel_code do |a, s|
    a.instance.hotel.code
  end

  Paperclip.interpolates :hotel_chain_code do |a, s|
    a.instance.hotel_chain.code
  end

  def activate(hotel = nil)
    User.transaction do
      self.activated_at = Time.now.utc
      self.activation_code = nil
      self.save!
    end

    UserNotifier.activation(self, hotel).deliver unless guest?
  end

  def deactivate
    User.transaction do
      self.activated_at = nil
      self.login_count = 0
      self.save!
    end
  end

  # Set the attribute if it is not present
  def set_if_empty(value, attribute)
    self[attribute] = value unless self[attribute].present?
  end

  # Returns a hash of user details for the contact information tab
  # Find user by reservation details
  def self.for_reservation_details(hotel_id, attributes)
    hotel = Hotel.find(hotel_id)

    # Find a user for a reservation with the same hotel id and guest_id
    user_id = Reservation.where(hotel_id: hotel_id, guest_id: attributes['guest_id']).pluck(:user_id).first

    # If no user is found, lookup by matching membership card number, type, and chain_id
    user_id = UserMembership.includes(:user).where('membership_card_number = ? AND membership_type = ? AND users.hotel_chain_id = ?', attributes['membership_card_number'], attributes['membership_type'], hotel.hotel_chain_id).first.andand.user_id unless user_id

    user_id ? User.find(user_id) : nil
  end

  def active?
    activation_code.nil? && activated_at.present?
  end

  def detail
    (self.hotel_staff? ||  self.hotel_admin? || self.admin?) ?  staff_detail : guest_detail
  end

  def full_name
    [detail.andand.first_name, detail.andand.last_name].compact.join(' ')
  end

  def display_name
    if detail.first_name
      detail.first_name
    else
      email
    end
  end

  def get_auto_logout_delay
    if hotel
      hotel.auto_logout_delay.nil? ? Setting.defaults[:default_auto_logout_delay].minutes : hotel.auto_logout_delay.minutes
    else
      Setting.defaults[:default_auto_logout_delay].minutes
    end
  end

  def password_expired?
    return false if last_password_update_at.blank?
    hotel_have_password_expiry = self.default_hotel.present? && self.default_hotel.settings.password_expiry.present? && self.default_hotel.settings.password_expiry.to_i <= Setting.defaults[:max_password_expiry]
    
    last_password_update_at <= Date.today - (hotel_have_password_expiry ? self.default_hotel.settings.password_expiry.to_i.days : Setting.defaults[:max_password_expiry].days)
  end

  def self.authenticate(email, password)
    errors = []
    notifications = ""
    redirect_url = ""
    token = ""
    user = User.find_by_login(email)

    user_session = UserSession.new(login: email, password: password)
    request = Thread.current[:current_request]
    if (user && user.admin? && user.first_login? && password == Setting.default_admin_password) || (user && !user.admin? && !user.api_user? && !user.guest? && (!user.last_password_update_at || user.password_expired?) && user_session.save)
      # Trigger Activation mail to the user 
      user.activate(user.default_hotel)
      # resetting perishable token to hack authlogic perishable token expire after 10 minutes
      # so that SNT Admin password can be reset even after 10 minutes of database reset migration
      user_session.destroy unless user_session.nil?
      user.reset_perishable_token!
      token = user.perishable_token
      notifications = I18n.t(:password_expired) if user.password_expired?
      message = I18n.t(:admin_first_login)
    else

      if !user || !user_session.save
        if user_session.errors.full_messages.join.include?("Consecutive failed")
          errors << user_session.errors.full_messages.join
        else
          errors << I18n.t(:invalid_login)
        end
        message = I18n.t(:invalid_login)
      else
        current_user = user_session.record

        # sets auto logout delay for Rover - START
        UserSession.logout_on_timeout = true
        current_user.class.logged_in_timeout = current_user.get_auto_logout_delay
        # sets auto logout delay for Rover - END

        user.update_attribute(:last_login_at, Time.now)
        if current_user.admin?
          redirect_url = "/admin"
        elsif current_user.hotel_staff? ||  current_user.hotel_admin?
          redirect_url = "/staff"
          message = I18n.t(:staff_login)
        else
          user_session.destroy
          errors << I18n.t(:no_role_to_login)
          message = I18n.t(:no_role_to_login)
        end
      end
    end
    
    if message == I18n.t(:invalid_login)
      activity_status = Setting.user_activity[:failure]
      action_type = Setting.user_activity[:invalid_login]
    else
      activity_status = Setting.user_activity[:success]
      action_type = Setting.user_activity[:login]
    end
    user.record_user_activity(:ROVER, user.hotel.id, action_type, activity_status, message, request.remote_ip) if user && !user.admin?
    
    resultant_response = {status: errors.empty? ? SUCCESS : FAILURE, data: {redirect_url: redirect_url, token: token, notifications: notifications }, errors: errors}
  end

  def self.authenticate_guest(params, is_zest = false)
    result = {}
    request = Thread.current[:current_request]
    @user_session = UserSession.new(login: params[:email], password: params[:password], remember_me: params[:remember_me])
    if params[:chain_code]
      hotel_chain = HotelChain.find_by_code(params[:chain_code])
      user = User.find_by_login_and_hotel_chain_id(params[:email], hotel_chain.id) if hotel_chain
    else
      user = User.find_by_login(params[:email])
    end

    if !user
      status, data, errors = FAILURE, {}, I18n.t(:invalid_user)
      message = I18n.t(:invalid_user)
    else
    # If user is guest and request has no chain code then clear the found user since the guest should always have chain associated
      if user.guest? && !params[:chain_code]
        status, data, errors = FAILURE, {}, I18n.t(:invalid_hotel_chain)
        message = I18n.t(:invalid_hotel_chain)
        user = nil
      end
    end
    is_valid_user = user.present?
    is_valid_user = user.guest? if is_zest
   
    if is_valid_user
      # Authenticate user
      if @user_session.save
        pms_session = PmsSession.find_by_user_id(user.id)
        pms_session = PmsSession.create(session_id: SecureRandom.hex, user_id: user.id) unless pms_session
        result =  { status: true , errors: [], data: pms_session }
        message = I18n.t(:guest_login_success)
      else
        result =  { status: false , errors: [@user_session.errors.full_messages.to_sentence]}
        message = @user_session.errors.full_messages.to_sentence
      end
    else
      result =  { status: false , errors: [I18n.t(:invalid_guest)] }
      message = I18n.t(:invalid_guest)
    end

    if status
      activity_status = Setting.user_activity[:success]
      action_type = Setting.user_activity[:login]
    else
      activity_status = Setting.user_activity[:failure]
      action_type = Setting.user_activity[:invalid_login]
    end
    if user && !user.admin?
      user.hotel_chain.hotels.each do | hotel |
        user.record_user_activity(:ZEST, hotel.id, action_type, activity_status, message, request.remote_ip)
      end
    end
    result
  end


  def recent_reservation
    reserved_status_id = Ref::ReservationStatus[:RESERVED].id
    inhouse_id = Ref::ReservationStatus[:CHECKEDIN].id
    checked_out_id = Ref::ReservationStatus[:CHECKEDOUT].id
    recent_reservation = self.guest_detail.reservations.where('reservations.status_id=?', inhouse_id).order('dep_date ASC').first
    recent_reservation = self.guest_detail.reservations.where('reservations.status_id=?', reserved_status_id).order('arrival_date ASC').first unless recent_reservation
    recent_reservation = self.guest_detail.reservations.where('reservations.status_id=?', checked_out_id).order('dep_date DESC').first unless recent_reservation
    recent_reservation
  end

  def active_cashier_period
    self.cashier_periods.where(status: 'OPEN').order('ends_at DESC').first
  end

  def last_cashier_period
    self.cashier_periods.where(status: 'CLOSED').order('ends_at DESC').first
  end

   # Add entries to the User Activity Table.
  def record_user_activity(application, hotel_id, action_type, activity_status, message, user_ip_address )
    hotel = Hotel.find(hotel_id)
    activity_date_time = DateTime.strptime(hotel.active_business_date.strftime("%Y %m %d ") + Time.now.utc.in_time_zone(hotel.tz_info).strftime("%H %M %S %:z"),'%Y %m %d %H %M %S %z')
    @activity = user_activities.create!( application: application, hotel_id: hotel_id, action_type: action_type,
                                 activity_status: activity_status, message: message, user_ip_address: user_ip_address, activity_date_time: activity_date_time)

    @activity.save!
  end
  
end
