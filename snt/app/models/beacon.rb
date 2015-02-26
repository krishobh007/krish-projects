class Beacon < ActiveRecord::Base
  attr_accessible :location, :uuid, :type_id, :is_active, 
                  :trigger_range_id, :notification_text,:hotel_id, :promotion_id,
                  :type, :trigger_range, :updated_at, :is_linked
  
  belongs_to :hotel
  belongs_to :promotion, :class_name => "Promotion", :foreign_key => "promotion_id"
  
  has_many :neighbourhoods
  has_many :neighbours, :through => :neighbourhoods
  
  has_many :inverse_neighbourhoods, :class_name => "Neighbourhood"
  has_many :inverse_neighbours, :through => :inverse_neighbourhoods, :source => :beacon
  
  validates_presence_of :uuid, :location, :hotel_id, :trigger_range_id, :type_id
  validates_uniqueness_of :uuid, scope: [:hotel_id]
  
  has_enumerated :type, class_name: 'Ref::BeaconType'
  has_enumerated :trigger_range, class_name: 'Ref::BeaconRange'
  
  def add_neighbour(neighbour)
    self.neighbours << neighbour
    neighbour.neighbours << self
  end
  
  def remove_neighbours
    neighbours = Neighbourhood.where(:beacon_id => self.id)
    neighbouring_beacons = Neighbourhood.where(:neighbour_id => self.id)
    neighbours.delete_all
    neighbouring_beacons.delete_all
  end

  scope :sort_by, lambda { |sort_field, sort_dir|
    sort_order = sort_dir != 'false' ? 'asc' : 'desc'

    results = scoped

    case sort_field
    when 'location'
      results = results.order("location #{sort_order}")
    when 'beacon_type'
      results = results.order("type_id #{sort_order}")
    when 'beacon_id'
      results = results.order("uuid #{sort_order}")
    when 'status'
      results = results.order("is_active #{sort_order}")
    end

  }
  
  
end
