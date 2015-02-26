class UpdateCleanToNotReady < ActiveRecord::Migration
  def change
    execute "update external_mappings set value = 'NOTREADY' where external_value = 'CL' and mapping_type = 'HK_STATUS' and hotel_id is null"
  end
end
