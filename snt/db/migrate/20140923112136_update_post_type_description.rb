class UpdatePostTypeDescription < ActiveRecord::Migration
  def change
    execute('update ref_post_types set description = "First Night" where value = "NIGHT"')
    execute('update ref_post_types set description = "Entire Stay" where value = "STAY"')
  end
end
