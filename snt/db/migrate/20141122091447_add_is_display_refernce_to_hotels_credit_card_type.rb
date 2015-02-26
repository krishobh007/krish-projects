class AddIsDisplayRefernceToHotelsCreditCardType < ActiveRecord::Migration
  def change
    add_column :hotels_credit_card_types, :is_display_reference, :boolean, :default => false
  end
end
