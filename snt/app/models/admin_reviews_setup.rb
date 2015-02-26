# View Model for the reviews admin page
class AdminReviewsSetup
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :hotel, :is_guest_reviews_on, :rating_for_auto_publish, :reviews_per_page

  validates :rating_for_auto_publish, numericality: { only_integer: true }
  validates :reviews_per_page, numericality: { less_than_or_equal_to: 100, only_integer: true, greater_than: 0 }

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      hotel.settings.is_guest_reviews_on = is_guest_reviews_on
      hotel.settings.rating_for_auto_publish = rating_for_auto_publish
      hotel.settings.reviews_per_page = reviews_per_page

      true
    else
      false
    end
  end

  def attributes=(attributes)
    attributes = (attributes || {}).symbolize_keys
    attributes.keys.each do |k|
      if self.class.instance_methods.include?(:"#{k}=")
        send(:"#{k}=", attributes[k])
      end
    end
  end
end
