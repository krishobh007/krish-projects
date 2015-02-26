json.array! @attached_entity_map do |attached_entity|
  json.id attached_entity[:entity].id
  json.name attached_entity[:entity_type]== Setting.routing_entity_types[:reservation] ? attached_entity[:entity].primary_guest.full_name : attached_entity[:entity].account_name
  json.guest_id attached_entity[:guest_id]
  json.entity_type attached_entity[:entity_type]
  json.from_bill attached_entity[:from_bill]
  json.to_bill attached_entity[:to_bill]
  json.reservation_status attached_entity[:reservation_status]
  json.is_opted_late_checkout attached_entity[:late_checkout_time]
  json.bill_no attached_entity[:bill_no]
  json.selected_payment attached_entity[:selected_payment_id]
  json.images attached_entity[:images]
  json.has_accompanying_guests attached_entity[:has_accompanying_guests]
  json.attached_charge_codes attached_entity[:attached_charge_codes]
  json.attached_billing_groups attached_entity[:attached_billing_groups]
  json.credit_card_details attached_entity[:credit_card_details]
end