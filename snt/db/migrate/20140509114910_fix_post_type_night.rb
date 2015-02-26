class FixPostTypeNight < ActiveRecord::Migration
  def change
    execute('update ref_post_types set description = "Per Night" where value = "NIGHT"')
  end
end
