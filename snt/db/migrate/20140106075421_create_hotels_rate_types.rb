class CreateHotelsRateTypes < ActiveRecord::Migration
  def change
    create_table :hotels_rate_types do |t|
      t.references :hotel
      t.references :rate_type
    end
  end
end
