class AddDefaultValuesToJoinTable < ActiveRecord::Migration
  def change
    change_column :messages_recipients, :is_read, :boolean, :default => false
  end
end
