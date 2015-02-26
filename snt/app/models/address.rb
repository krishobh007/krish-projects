class Address < ActiveRecord::Base
  attr_accessible :label, :label_id, :street1, :street2, :street3, :city, :state, :postal_code, :country_id, :is_primary, :external_id

  belongs_to :guest_detail
  belongs_to :country
  
  belongs_to :associated_address, polymorphic: true
  
  
  has_enumerated :label, class_name: 'Ref::ContactLabel'
  
  validates :label_id,
            presence: true

  # Only returns primary contact info
  scope :primary, -> { where(is_primary: true) }

  # Returns the City, State
  def city_state
    [city.to_s, state.to_s].reject { |e| e.empty? }.compact.join(', ')
  end
end
