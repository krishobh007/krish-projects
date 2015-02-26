class FixHkDescriptions < ActiveRecord::Migration
  def change
    execute('update ref_housekeeping_statuses set description = "Out Of Service" where value = "OS"')
    execute('update ref_housekeeping_statuses set description = "Out Of Order" where value = "OO"')
  end
end
