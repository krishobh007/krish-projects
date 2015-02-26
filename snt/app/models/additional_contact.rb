class AdditionalContact < ActiveRecord::Base
  attr_accessible :contact_type, :contact_type_id, :label, :label_id, :value, :is_primary, :external_id, :associated_address_id

  belongs_to :associated_address, polymorphic: true
  has_enumerated :label, class_name: 'Ref::ContactLabel'
  has_enumerated :contact_type, class_name: 'Ref::ContactType'

  validates :contact_type_id, :label_id, presence: true
  validates :value, format: { with: /\A([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})\Z/, message: :email }, allow_nil: true, if: :email?
  validates :value, uniqueness: { scope: [:contact_type_id, :label_id, :associated_address_id], case_sensitive: false }, if: :associated_address_id?

  scope :home, -> { with_label(:HOME) }
  scope :mobile, -> { with_label(:MOBILE) }

  # Only returns primary contact info
  scope :primary, -> { where(is_primary: true) }

  def email?
    contact_type === :EMAIL
  end

  def phone?
    contact_type === :PHONE
  end
end