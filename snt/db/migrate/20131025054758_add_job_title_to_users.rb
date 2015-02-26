class AddJobTitleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :works_at, :string
    add_column :users, :job_title, :string
  end
end
