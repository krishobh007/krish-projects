class RemoveFieldsFromAddress < ActiveRecord::Migration
  def up
    remove_column :addresses,:guest_detail_id
  end
end
