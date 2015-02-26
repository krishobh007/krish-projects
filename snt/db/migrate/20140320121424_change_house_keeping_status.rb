class ChangeHouseKeepingStatus < ActiveRecord::Migration
  def change
    # Update the External Mappings Entery
    execute "update external_mappings set value = 'CLEAN' where external_value='CL' and mapping_type='HK_STATUS'"
    execute "update external_mappings set value = 'INSPECTED' where external_value='IP' and mapping_type='HK_STATUS'"
    execute "update external_mappings set value = 'DIRTY' where external_value='DI' and mapping_type='HK_STATUS'"
    execute "update external_mappings set value = 'OS' where external_value='OS' and mapping_type='HK_STATUS'"
    execute "update external_mappings set value = 'OO' where external_value='OO' and mapping_type='HK_STATUS'"

    # Update the ref_house_keeping_status
    execute "update  ref_housekeeping_statuses set value='CLEAN', description = 'Clean' where id = 1"
    execute "update  ref_housekeeping_statuses set value='INSPECTED', description = 'Inspected' where id = 2"
    execute "update  ref_housekeeping_statuses set value='DIRTY', description = 'Dirty' where id = 3"
    execute "update  ref_housekeeping_statuses set description = 'OutOfService' where id = 4"
    execute "update  ref_housekeeping_statuses set description = 'OutOfOrder' where id = 5"
  end
end
