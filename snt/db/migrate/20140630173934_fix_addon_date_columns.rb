class FixAddonDateColumns < ActiveRecord::Migration
  def change
    execute('update addons set begin_date = null where begin_date = ""')
    execute('update addons set end_date = null where end_date = ""')

    change_column :addons, :begin_date, :date
    change_column :addons, :end_date, :date
  end
end
