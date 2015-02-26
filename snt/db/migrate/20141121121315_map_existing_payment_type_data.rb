class MapExistingPaymentTypeData < ActiveRecord::Migration
  def up
    
    Hotel.all.each do |hotel|
      PaymentType.where(:hotel_id => nil).each do |p_type|
        if hotel.payment_types.include?(p_type)
          hotel_payment_type = HotelsPaymentType.find_or_create_by_hotel_id_and_payment_type_id(hotel.id, p_type.id)
          
          is_cc_flag = false
          
          if p_type.id == PaymentType.credit_card.id
            is_cc_flag = true
          end
          hotel_payment_type.is_cc          = is_cc_flag
          hotel_payment_type.is_offline     = false
          hotel_payment_type.is_rover_only  = false
          hotel_payment_type.is_web_only    = false
          hotel_payment_type.active         = true
          hotel_payment_type.save
        end
      end
    end 
  end

  def down
  end
end
