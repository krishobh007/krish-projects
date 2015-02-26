class RemoveDuplicationFieldsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :birthday
    remove_column :users, :gender
    remove_column :users, :vip
    remove_column :users, :title
    remove_column :users, :company
    remove_column :users, :works_at
    remove_column :users, :passport_no
    remove_column :users, :passport_expiry
    remove_column :users, :image_url
    remove_column :users, :job_title
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
  end

  def down
    add_column :users, :birthday, :date
    add_column :users, :gender, :string
    add_column :users, :vip, :boolean
    add_column :users, :title, :string
    add_column :users, :company, :string
    add_column :users, :works_at, :string
    add_column :users, :passport_no, :string
    add_column :users, :passport_expiry, :date
    add_column :users, :image_url, :string
    add_column :users, :job_title, :string
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_updated_at, :datetime
  end
end
