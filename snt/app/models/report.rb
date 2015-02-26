class Report < ActiveRecord::Base
  attr_accessible :description, :method, :title, :sub_title, :filters

  has_and_belongs_to_many :filters, uniq: true, class_name: 'Ref::ReportFilter', join_table: 'report_filters',
                          association_foreign_key: 'filter_id'
  has_and_belongs_to_many :sortable_fields, uniq: true, class_name: 'Ref::ReportSortableField', join_table: 'report_sortable_fields',
                          association_foreign_key: 'sortable_field_id'

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  scope :exclude_upsell, -> { where("title != 'Upsell'") }
  scope :exclude_late_checkout, -> { where("title != 'Late Check Out'") }

  def process(hotel, filter)
    Object.const_get(method.camelize).new(hotel, filter).process
  end
end
