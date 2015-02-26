class ChargeGroupsCodes < ActiveRecord::Migration
  def change
    create_table :charge_groups_codes do |t|
      t.references :charge_group
      t.references :charge_code
      t.timestamps

    end
  end
end
