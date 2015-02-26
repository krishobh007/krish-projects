module SeedExternalMappings
  def create_external_mappings
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'RESERVED', external_value: 'DUEIN', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'CHECKEDIN', external_value: 'INHOUSE', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'CHECKEDIN', external_value: 'DUEOUT', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'CHECKEDIN', external_value: 'CHECKEDIN', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'RESERVED', external_value: 'RESERVED', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'CHECKEDOUT', external_value: 'CHECKEDOUT', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'CANCELED', external_value: 'CANCELED', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'CANCELED', external_value: 'CANCELLED', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'NOSHOW', external_value: 'NOSHOW', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'CHECKEDIN', external_value: 'WALKIN', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'RESERVATION_STATUS', value: 'RESERVED', external_value: 'CHANGED', pms_type: :OWS)

    ExternalMapping.create(mapping_type: 'CURRENCY_CODE', value: 'USD', external_value: 'USD', pms_type: :OWS)

    ExternalMapping.create(mapping_type: 'FO_STATUS', value: 'OCCUPIED', external_value: 'OCC', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'FO_STATUS', value: 'VACANT', external_value: 'VAC', pms_type: :OWS)

    ExternalMapping.create(mapping_type: 'HK_STATUS', value: 'CLEAN', external_value: 'CL', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'HK_STATUS', value: 'INSPECTED', external_value: 'IP', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'HK_STATUS', value: 'DIRTY', external_value: 'DI', pms_type: :OWS)
    # Out of Order Rooms
    ExternalMapping.create(mapping_type: 'HK_STATUS', value: 'OS', external_value: 'OS', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'HK_STATUS', value: 'OO', external_value: 'OO', pms_type: :OWS)
    ExternalMapping.create(mapping_type: 'HK_STATUS', value: 'PICKUP', external_value: 'PU', pms_type: :OWS)
  end
end
