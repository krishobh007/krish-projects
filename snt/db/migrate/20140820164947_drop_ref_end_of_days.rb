class DropRefEndOfDays < ActiveRecord::Migration
  def change
    drop_table :ref_end_of_days
  end
end
