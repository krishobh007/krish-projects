class UpdateExistingHotelsWithBeaconMajorUuid < ActiveRecord::Migration
  def change
    # As per merging ng-develop to develop, adding following content into this mighration
    add_column :hotels, :default_date_format_id, :integer

    hotels = Hotel.all
    random = Random.new
    hotels.each do |hotel|

      hotel.update_attributes(:beacon_uuid_major => random.rand(1...65535))

    end
  end
end
