class AddStaffDetailsTable < ActiveRecord::Migration
  def change
    create_table :staff_details do |t|
     t.integer :id
     t.references :user
     t.string :first_name
     t.string :last_name
     t.string :job_title
     t.string :title
     t.string :avatar_file_name
     t.string :avatar_content_type
     t.integer :avatar_file_size
     t.datetime :avatar_updated_at

     t.timestamps
   end
 end
end
