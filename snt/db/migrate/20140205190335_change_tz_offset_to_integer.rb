class ChangeTzOffsetToInteger < ActiveRecord::Migration
  def change
    execute 'update hotels set tz_offset = null'
    change_column :hotels, :tz_offset, :integer
  end
end
