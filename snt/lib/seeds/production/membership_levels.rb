module SeedMembershipLevels
  def create_membership_levels
    membership_type1 = MembershipType.find_by_value('AW')
    membership_type2 = MembershipType.find_by_value('AA')

    MembershipLevel.create(
      membership_level: 'BASIC',
      description: 'Basic',
      membership_type_id: membership_type1.id
    )

    MembershipLevel.create(
      membership_level: 'GOLD',
      description: 'Gold',
      membership_type_id: membership_type1.id
    )

    MembershipLevel.create(
      membership_level: 'SLV',
      description: 'Silver',
      membership_type_id: membership_type2.id
    )
  end
end
