module SeedPaymentTypes
  def create_payment_types
    PaymentType.create(value: 'CC', description: 'Credit Card')
    PaymentType.create(value: 'DB', description: 'Direct Bill', is_selectable: false)
    PaymentType.create(value: 'CA', description: 'Cash Payment', is_selectable: false)
    PaymentType.create(value: 'CK', description: 'Check Payment', is_selectable: false)
    
    Hotel.all.each do |hotel|
      
      PaymentType.where(:hotel_id => nil).each do |p_type|
        cc_flag = false
        if not hotel.payment_types.include?(p_type)
          
          if p_type.id == PaymentType.credit_card.id
            cc_flag = true
          end
          HotelsPaymentType.create(
            :payment_type   => p_type,
            :hotel          => hotel,
            :is_cc          => cc_flag,
            :is_offline     => false,
            :is_rover_only  =>  false,
            :is_web_only    => false,
            :active         => false
          )
        end
      end
      
      PaymentType.where(:hotel_id => hotel.id).each do |p_type|
        if not hotel.payment_types.include?(p_type)
          HotelsPaymentType.create(
            :payment_type   => p_type,
            :hotel          => hotel,
            :is_cc          => false,
            :is_offline     => false,
            :is_rover_only  =>  false,
            :is_web_only    => false,
            :active         => p_type.is_selectable
          )
        end
      end
      
      Ref::CreditCardType.all.each do |credit_card_type|
        active = false
        if hotel.credit_card_types.include?(credit_card_type)
          hotel_credit_card_type = HotelsCreditCardType.where(:hotel_id => hotel.id, :ref_credit_card_type_id => credit_card_type.id).first
          next if hotel_credit_card_type.is_cc == true
          active = true
        end
        hotel_credit_card_type = HotelsCreditCardType.find_or_create_by_ref_credit_card_type_id_and_hotel_id(credit_card_type.id, hotel.id)
        hotel_credit_card_type.update_attributes(
          :is_cc          => true,
          :is_offline     => false,
          :is_rover_only  =>  false,
          :is_web_only    => false,
          :active         => active
        )
      end
      
    end
  end
end