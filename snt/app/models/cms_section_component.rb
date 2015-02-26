class CmsSectionComponent < ActiveRecord::Base
  attr_accessible :parent_id, :child_component_id

  belongs_to :parent_categories, foreign_key: "parent_id", class_name: "CmsComponent"
  belongs_to :sub_category, foreign_key: "child_component_id", class_name: "CmsComponent"
  validates :parent_id, :child_component_id, presence: true

end
