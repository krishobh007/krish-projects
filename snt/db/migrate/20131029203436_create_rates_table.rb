class CreateRatesTable < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.references :chain, null: false, index: true
      t.references :hotel, null: false, index: true
      t.string :rate_desc, null: false, limit: 80
      t.date :begin_date, null: false
      t.date :end_date
      t.date :sell_begin_date
      t.date :sell_end_date
      t.integer :parent_rate_id
      t.string :market_code, limit: 20
      t.string :currency_code, limit: 20
      t.integer :external_id

      t.references :created_by
      t.references :updated_by
      t.timestamps
    end
  end
end
