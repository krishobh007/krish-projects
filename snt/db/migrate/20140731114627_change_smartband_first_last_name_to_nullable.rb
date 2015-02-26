class ChangeSmartbandFirstLastNameToNullable < ActiveRecord::Migration
  def change
    change_column :smartbands, :first_name, :string, null: true
    change_column :smartbands, :last_name, :string, null: true
  end
end
