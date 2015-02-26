class ChangeRefPostTypeDayToNight < ActiveRecord::Migration
  def change
    execute('update ref_post_types set value = "NIGHT", description = "Night" where value = "DAY"')
  end
end
