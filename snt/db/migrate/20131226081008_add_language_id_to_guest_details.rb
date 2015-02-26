class AddLanguageIdToGuestDetails < ActiveRecord::Migration
  def change
    add_column :guest_details, :language_id, :integer
  end
end
