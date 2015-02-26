class CreateRateRestrictions < ActiveRecord::Migration
  def change
    create_table :rate_restrictions do |t|
      t.references :hotel, null: false
      t.references :rate, null: false
      t.references :type, null: false
      t.integer :days
      t.timestamps
      t.userstamps
    end

    remove_column :rates, :min_stay
    remove_column :rates, :max_stay
    remove_column :rates, :min_advanced_booking
    remove_column :rates, :max_advanced_booking
  end
end
