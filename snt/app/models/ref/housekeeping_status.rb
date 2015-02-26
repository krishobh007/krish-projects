class Ref::HousekeepingStatus < Ref::ReferenceValue
  # As per CICO-5861
  scope :exclude_os_oo, -> { where('id not in (?, ?)', Ref::HousekeepingStatus[:OO], Ref::HousekeepingStatus[:OS]) }
  scope :exclude_pickup, -> { where('id not in (?)', Ref::HousekeepingStatus[:PICKUP]) }
  scope :exclude_inspected, -> { where('id not in (?)', Ref::HousekeepingStatus[:INSPECTED]) }
  # House keeping List return based on the On/Off button  of Use Inspected/Use Pickup
  def self.get_housekeeping_status_list(is_inspected_on, is_pickup_on)
    results = self.exclude_os_oo

    results = results.exclude_pickup unless is_pickup_on

    results = results.exclude_inspected unless is_inspected_on

    self.mapped_hk_status(results)
  end

  def self.mapped_hk_status(hk_status_list)
    hk_status_list.map do |hk_status|
      { id: hk_status.id, value: hk_status.value.to_s, description: hk_status.description.to_s.titleize, ext_description: hk_status.description.to_s }
    end
  end
end
