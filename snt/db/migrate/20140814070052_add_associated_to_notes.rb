class AddAssociatedToNotes < ActiveRecord::Migration
  def change
     rename_column :notes, :reservation_id, :associated_id
     add_column :notes, :associated_type, :string
  end
end
