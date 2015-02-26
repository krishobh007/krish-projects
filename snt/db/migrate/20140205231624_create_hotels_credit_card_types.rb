class CreateHotelsCreditCardTypes < ActiveRecord::Migration
  def change
    create_table :hotels_credit_card_types, id: false do |t|
      t.references :hotel, index: true
      t.references :ref_credit_card_type, index: true
    end
  end
end
