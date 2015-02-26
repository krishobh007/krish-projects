class Action < ActiveRecord::Base
  attr_accessible :user_id, :hotel_id, :actionable_id, :actionable_type, :actionable, :action_type, :application, :business_date

  belongs_to :user
  belongs_to :hotel
  belongs_to :actionable, polymorphic: true

  has_many :details, class_name: 'ActionDetail', inverse_of: :action

  has_enumerated :action_type, class_name: 'Ref::ActionType'
  has_enumerated :application, class_name: 'Ref::Application'

  validates :hotel, :actionable, :action_type, :application, :business_date, presence: true

  scope :search, lambda { |filter|
    between_dates(filter[:from_date], filter[:to_date]).for_user(filter[:user_ids]).sort_by(filter[:sort_field], filter[:sort_dir])
  }

  scope :search_all, lambda { |filter|
    between_dates(filter[:from_date], filter[:to_date]).for_user(filter[:user_ids])
  }

  scope :join_reservation, lambda {
    joins("inner join reservations_guest_details on reservations_guest_details.reservation_id = actions.actionable_id and
          actionable_type = 'Reservation'")
  }

  scope :join_guest, lambda {
    join_reservation.joins('inner join guest_details on guest_details.id = reservations_guest_details.guest_detail_id')
      .where('reservations_guest_details.is_primary = 1')
  }

  # If from and/or to dates are provided, filter by them
  scope :between_dates, proc { |from_date, to_date|
    result = scoped
    result = result.where('? <= actions.business_date', from_date) if from_date.present?
    result = result.where('actions.business_date < ?', to_date + 1.day) if to_date.present?
    result
  }

  # If staff ids are provided, add condition to filter by it
  scope :for_user, proc { |user_ids|
    result = scoped
    result = result.includes(creator: :staff_detail).where('staff_details.user_id in (:user_ids)', user_ids: user_ids) if user_ids.present?
    result
  }

  # Sort by field and direction
  scope :sort_by, lambda { |sort_field, sort_dir|
    sort_order = sort_dir ? 'asc' : 'desc'

    result = scoped

    case sort_field
    when 'USER'
      result.join_guest.order("guest_details.first_name #{sort_order}")
    else
      result.order("actions.business_date #{sort_order}")
    end
  }

  scope :group_by_type_app_date, -> { group(:action_type_id, :application_id, :business_date) }
  scope :group_by_type_app, -> { group(:action_type_id, :application_id) }
  scope :group_by_month, -> { group('YEAR(business_date)', 'MONTH(business_date)') }

  scope :group_by_detail, lambda { |key|
    joins('INNER JOIN action_details gad on gad.action_id = actions.id').where('gad.key = ?', key).group('gad.new_value')
  }

  scope :group_by_old_and_new, lambda { |key|
    joins('INNER JOIN action_details gad on gad.action_id = actions.id').where('gad.key = ?', key).group('gad.old_value', 'gad.new_value')
  }

  # Adds a record to the actions table for the provided actionable object and action_type. Optionally, a details array
  # containing hashes of key, old_value, and new_value can also be provided.
  def self.record!(actionable, action_type, application, hotel_id, details = [])
    # Build the new action
    hotel = Hotel.find(hotel_id)
    business_date = hotel.active_business_date
    action = Action.new(actionable: actionable, action_type: action_type, application: application, hotel_id: hotel_id, business_date: business_date)

    # Add the details to the action, if there are any
    details.each do |detail|
      action.details.build(detail)
    end

    # Save the action and its details
    action.save!
  end

  def old_value(key)
    details.where(key: key).first.andand.old_value
  end

  def new_value(key)
    details.where(key: key).first.andand.new_value
  end

  # Sums all of the details that have the provided key
  def self.sum_details(key)
    joins(:details).where('action_details.key = ?', key).sum('action_details.new_value')
  end

  # Sums all of the details that have the provided key
  def self.with_detail(key, new_value)
    joins(:details).where('action_details.key = ? action_details.new_value = ?', key, new_value)
  end
end
