class AddJobTitleToGuestDetails < ActiveRecord::Migration
  def change
    add_column :guest_details, :job_title, :string
  end
end
