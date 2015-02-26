module SeedTestExternalMappings
  def create_test_external_mappings
    hotel = Hotel.find_by_code('DOZERQA')
    hotel_id = hotel.id

    ExternalMapping.create(mapping_type: 'ADDRESS_TYPE', value: 'HOME', external_value: 'HOME', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'ADDRESS_TYPE', value: 'HOME', external_value: 'H', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'ADDRESS_TYPE', value: 'BUSINESS', external_value: 'BUSINESS', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'ADDRESS_TYPE', value: 'BUSINESS', external_value: 'B', pms_type: :OWS, hotel_id: hotel_id)

    ExternalMapping.create(mapping_type: 'PHONE_TYPE', value: 'HOME', external_value: 'HOME', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PHONE_TYPE', value: 'BUSINESS', external_value: 'BUSINESS', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PHONE_TYPE', value: 'MOBILE', external_value: 'MOBILE', pms_type: :OWS, hotel_id: hotel_id)

    ExternalMapping.create(mapping_type: 'EMAIL_TYPE', value: 'HOME', external_value: 'EMAIL', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'EMAIL_TYPE', value: 'HOME', external_value: 'EMAIL HOME', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'EMAIL_TYPE', value: 'BUSINESS', external_value: 'B_EMAIL', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'EMAIL_TYPE', value: 'BUSINESS', external_value: 'EMAIL BUSINESS', pms_type: :OWS, hotel_id: hotel_id)

    # Mappings for prefrence types
    ExternalMapping.create(mapping_type: 'PREFERENCE_TYPE', value: 'ROOM FEATURE', external_value: 'ROOM FEATURES', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_TYPE', value: 'NEWSPAPER', external_value: 'NEWSPAPER', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_TYPE', value: 'SMOKING', external_value: 'SMOKING', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_TYPE', value: 'FLOOR', external_value: 'FLOOR', pms_type: :OWS, hotel_id: hotel_id)

    # Mappings for preference values
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'POOL VIEW', external_value: 'POOL', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'TERRACE', external_value: 'TRC', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'SMOKING', external_value: 'S', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'NON-SMOKING', external_value: 'NS', pms_type: :OWS, hotel_id: hotel_id)

    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'BALCONY', external_value: 'BAL', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'CONNECTING ROOM', external_value: 'CON', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'SPA', external_value: 'SPA', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'BOSTON HERALD', external_value: 'BH', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'CROATIAN TIMES', external_value: 'CT', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'SUEDDEUTSCHE ZEITUNG', external_value: 'SZ', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'SYDNEY MORNING HERALD', external_value: 'SMH', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'USA TODAY', external_value: 'USA', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'HIGH', external_value: 'HIGH', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'PREFERENCE_VALUE', value: 'LOW', external_value: 'LOW', pms_type: :OWS, hotel_id: hotel_id)

    ExternalMapping.create(mapping_type: 'MEMBER_CLASS', value: 'FFP', external_value: 'AIR', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_CLASS', value: 'FFP', external_value: 'FF', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_CLASS', value: 'HLP', external_value: 'LP', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_CLASS', value: 'HLP', external_value: 'LPP', pms_type: :OWS, hotel_id: hotel_id)

    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'DL', external_value: 'DL', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'AA', external_value: 'AA', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'IT', external_value: 'AZ', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'AK', external_value: 'AS', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'BA', external_value: 'BA', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'IB', external_value: 'IB', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'US', external_value: 'US', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'SW', external_value: 'WN', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'UA', external_value: 'UA', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'NW', external_value: 'NW', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'LA', external_value: 'LA', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'LU', external_value: 'LH', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'SI', external_value: 'SQ', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'AW', external_value: 'AW', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'SCL', external_value: 'SCL', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'SE', external_value: 'SE', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'MEMBER_TYPE', value: 'GHA', external_value: 'GHA', pms_type: :OWS, hotel_id: hotel_id)

    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'VA', external_value: 'VI', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'AX', external_value: 'AX', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'MC', external_value: 'MC', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'DC', external_value: 'DC', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'DS', external_value: 'DS', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'JCB', external_value: 'JC', pms_type: :OWS, hotel_id: hotel_id)
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'DB', external_value: 'DB', pms_type: :OWS, hotel_id: hotel_id) # DIRECT BILL PAYMENT TYPE
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'CA', external_value: 'CA', pms_type: :OWS, hotel_id: hotel_id) # CASH PAYMENT TYPE
    ExternalMapping.create(mapping_type: 'CC_TYPE', value: 'CK', external_value: 'CK', pms_type: :OWS, hotel_id: hotel_id) # CHECK PAYMENT TYPE
  end
end
