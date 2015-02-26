class AddBusinessDateToActions < ActiveRecord::Migration
  def change
    add_column :actions, :business_date, :date
    execute('update actions set business_date = date(created_at)')
    change_column :actions, :business_date, :date, null: false
  end
end
