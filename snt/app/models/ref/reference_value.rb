# This is an abstract model that all other reference tables extend
class Ref::ReferenceValue < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'ref_'

  attr_accessible :value, :description

  validates :value, presence: true, uniqueness: { case_sensitive: false }

  # Configures the power enum gem for all reference tables. Raise exception if symbol lookup fails.
  acts_as_enumerated name_column: 'value'

  default_scope { order('description ASC') }
end
