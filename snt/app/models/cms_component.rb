class CmsComponent < ActiveRecord::Base
  attr_accessible :name, :hotel_id, :component_type, :description, :address, :website_url, :phone, :page_template,
  :status, :latitude, :longitude, :valid_branch_count

  has_one :icon, class_name: 'Image', as: :image_attachable
  has_one :image, class_name: 'Image', as: :image_attachable

  belongs_to :hotel

  has_many :parents, foreign_key: 'child_component_id', class_name: 'CmsSectionComponent'
  has_many :parent_categories, through: :parents
  has_many :child_components, foreign_key: 'parent_id', class_name: 'CmsSectionComponent'
  has_many :sub_categories, through: :child_components
  has_many :cms_section_components, foreign_key: 'child_component_id', class_name: 'CmsSectionComponent'

  validates :name, :component_type, :hotel_id, presence: true

  validate :validate_address

  validates_uniqueness_of :name, scope: [:component_type, :hotel_id]

  validate :validate_phone
  validates_presence_of :website_url, :if  => :check_url
  validates :website_url, :url => {:allow_blank => true}

  scope :sections, -> { where(component_type: Setting.component_types[:section]) }
  scope :pages, -> { where(component_type: Setting.component_types[:page]) }
  scope :categories, -> { where(component_type: Setting.component_types[:category]) }

  scope :published, -> { where('cms_components.status = true') }

  def has_valid_branches?
   component_type == Setting.component_types[:page] || ( component_type != Setting.component_types[:page] && valid_branch_count > 0 )
  end

  def is_page?
    component_type == Setting.component_types[:page]
  end

  def is_section?
    component_type == Setting.component_types[:section]
  end

  def is_category?
    component_type == Setting.component_types[:category]
  end


  def save_component_attributes(attributes)
    component_attributes = {}
    [:name, :hotel_id, :component_type, :status, :description, :address, :website_url, :phone, :page_template].each do |key|
      component_attributes[key] = attributes[key]  if attributes.key?(key)
    end

    set_image_from_base64(attributes[:icon], 'icon') if attributes[:icon].present?
    set_image_from_base64(attributes[:image], 'image') if attributes[:image].present?
    update_attributes!(component_attributes)
  end

  Paperclip.interpolates :component_prefix do |a, s|
    "#{a.instance.hotel.hotel_chain.code}/#{a.instance.hotel.code}"
  end

  def set_image_from_base64(base64_data, image_type)

    base64_data = base64_data.split('base64,')[1]

    file_name = "#{image_type}#{Time.now.utc.to_i}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(Base64.decode64(base64_data))
    end
    if image_type == 'icon'
      icon_file = File.open(image_path)
      self.icon = Image.new
      self.icon.image = icon_file
      self.icon.save!
    else
      image_file = File.open(image_path)
      self.image = Image.new
      self.image.image = image_file
      self.image.save!
    end
    File.delete(image_path)
  end

  def to_node
    self.attributes.merge(
    {
    icon: icon.andand.image.andand.url(:thumb),
    image: image.andand.image.andand.url(:thumb),
    children: sub_categories.map { |category| category.to_node }
    }
    )
  end

  def is_main_category
    ((parent_categories.first.component_type == Setting.component_types[:section]) && (component_type == Setting.component_types[:category]))
  end

  # Clear the coordinates and geocode the address into lat/lng if the address changed
  before_validation :clear_coordinates, :geocode if :address_changed?

  # Informs the geocoder gem to lookup the latitude/longitude using the address
  geocoded_by :address

  # Set the latitude and longitude to nil - should be done prior to geocoding
  def clear_coordinates
    self.latitude = nil
    self.longitude = nil
  end

  def section_items(items = [])
    @@items = [] if items.empty?
    sub_categories.each do |sub_category|
      if (sub_category.is_page?)
        @@items << sub_category.id unless @@items.include?(sub_category.id)
      elsif (sub_category.sub_categories.count > 0)
        sub_category.section_items(@@items)
      end
    end
    @@items
  end

  # Validate the address by ensuring the latitude and longitude are provided.
  def validate_address
    if ((is_page? && page_template == Setting.page_template[:poi]) && (!latitude.present? || !longitude.present?))
      errors.add(:address, 'is invalid')
    end
  end

  # Validate the presence of url if page template is "LINK"
  def check_url
    (is_page? && page_template == Setting.page_template[:link]) && (!website_url.present?)
  end

  # validates Phone number saved in page
  def validate_phone
    if is_page?
      validates_format_of :phone, :with => /^\+?\(?\d+\)?[\d\-\s]+$/, :allow_blank => true, message: 'is invalid. Please use (111)111-1111 format'
    end
  end

  # Method to count the no of valid branches assigned to a subcategory
  def update_branch_count(parent_categories, update_count)
    parent_categories.each  do |parent_category|
      if (is_page? && status) || is_page?
        parent_category.valid_branch_count += update_count
        parent_category.save
      elsif is_category?
        parent_category.valid_branch_count += update_count
        parent_category.save
      end
      unless parent_category.parent_categories.empty?
        parent_category.update_branch_count(parent_category.parent_categories, update_count)
      end
    end
  end
end
