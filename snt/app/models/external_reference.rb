class ExternalReference < ActiveRecord::Base
  attr_accessible :reference_type, :value, :description, :associated, :associated_type, :associated_id

  belongs_to :associated, polymorphic: true

  has_enumerated :reference_type, class_name: 'Ref::ExternalReferenceType'

  validates :reference_type, :value, :description, :associated, presence: true
  validates :value, uniqueness: { scope: [:reference_type_id, :associated_id, :associated_type], case_sensitive: false }
end
