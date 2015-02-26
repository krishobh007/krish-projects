class RemoveDuplicateMembershipTypes < ActiveRecord::Migration
  def change
    execute "delete a from membership_types a, membership_types b where a.id > b.id and a.value = b.value and
            a.property_id is null and b.property_id is null"

    execute "delete a from membership_types a, membership_types b where a.id > b.id and a.value = b.value and a.property_id = b.property_id and
            ((a.property_type = 'Hotel' and b.property_type = 'Hotel') or (a.property_type = 'HotelChain' and b.property_type = 'HotelChain'))"

    execute "delete a from membership_types a, membership_types b where a.id > b.id and a.value = b.value and
            a.property_type = 'Hotel' and b.property_type = 'HotelChain' and
            a.property_id in (select id from hotels where hotel_chain_id = b.property_id)"

    execute 'delete from membership_levels where membership_type_id not in (select id from membership_types)'
    execute 'delete from guest_memberships where membership_type_id not in (select id from membership_types)'
    execute 'delete from hotels_membership_types where membership_type_id not in (select id from membership_types)'
    execute 'delete from reservations_memberships where membership_id not in (select id from guest_memberships)'
  end
end
