class AddIndexesForReservationImport < ActiveRecord::Migration
  def change
    add_index :additional_contacts, [:associated_address_id, :external_id], name: 'idx_additional_contacts_external_id'
    add_index :additional_contacts, [:associated_address_id, :value], name: 'idx_additional_contacts_value'
    add_index :payment_types, [:hotel_id, :value]
    add_index :reservations_guest_payment_types, [:reservation_id], name: 'idx_res_pay_type_reservation_id'
    add_index :reservations_guest_payment_types, [:guest_payment_type_id], name: 'idx_res_pay_type_guest_payment_type_id'
    add_index :guest_payment_types, [:guest_detail_id]
    add_index :membership_types, [:property_id, :property_type, :value], name: 'idx_membership_types_prop_value'
    add_index :external_mappings, [:hotel_id, :mapping_type, :external_value], name: 'idx_ext_mapping_ext_value'
    add_index :external_mappings, [:hotel_id, :mapping_type, :value], name: 'idx_ext_mapping_value'
    add_index :guest_memberships, [:guest_detail_id]
  end
end
