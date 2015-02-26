class Image < ActiveRecord::Base
  attr_accessible :image
  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':class/:id/:attachment/:style/:filename',
                      default_url: :get_default_image

  belongs_to :image_attachable, polymorphic: true

  private

  def get_default_image
  end
end
