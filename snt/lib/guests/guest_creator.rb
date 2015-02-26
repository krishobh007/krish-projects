class GuestCreator
  
  def initialize(params, hotel_id)
    @params = params
    @guest_attributes = guest_attributes
    @hotel = Hotel.find(hotel_id)
    @guest_detail = @hotel.hotel_chain.guest_details.new(@guest_attributes)
  end
  
  def create
    params = @params
    GuestDetail.transaction do
      @guest_detail.save!
      save_associations!
    end
    @guest_detail
  rescue ActiveRecord::RecordInvalid => e
    {message: e.record.errors.full_messages, status: :unprocessable_entity}
  end
  
  def save_associations!
    save_email! if @params.key?(:email)
    save_phone! if @params.key?(:phone)
    save_mobile! if @params.key?(:mobile)
    save_address! if @params.key?(:address)
  end
  
  def save_email!
    email = @guest_detail.emails.primary.first if @guest_detail

    if @params[:email].present?
      if email
        email.update_attributes!(value: @params[:email])
      else
        @guest_detail.contacts.create!(value: @params[:email], contact_type: :EMAIL, label: :HOME, is_primary: true) if @guest_detail
      end
    elsif email
      email.destroy
    end
  end
  
  def save_phone!
    phone = @guest_detail.phones.home.first if @guest_detail

    if @params[:phone].present?
      if phone
        phone.update_attributes!(value: @params[:phone])
      else
        @guest_detail.contacts.create!(value: @params[:phone], contact_type: :PHONE, label: :HOME, is_primary: false) if @guest_detail
      end
    elsif phone
      phone.destroy
    end
  end
  
  def save_mobile!
    mobile = @guest_detail.phones.mobile.first if @guest_detail

    if @params[:mobile].present?
      if mobile
        mobile.update_attributes!(value: @params[:mobile])
      else
        @guest_detail.contacts.create!(value: @params[:mobile], contact_type: :PHONE, label: :MOBILE, is_primary: false) if @guest_detail
      end
    elsif mobile
      mobile.destroy
    end
  end
  
  def save_address!
    address = @guest_detail.addresses.primary.first if @guest_detail

    if @params[:address].present?
      if address
        address.update_attributes!(address_attributes)
      else
        @guest_detail.addresses.create!(address_attributes) if @guest_detail
      end
    end
  end

  
  def guest_attributes
    attributes = @params.slice(:title, :first_name, :last_name, :job_title, :works_at, :is_opted_promotion_email)
    attributes[:birthday] = Date.strptime(@params[:birthday], '%m-%d-%Y') if @params[:birthday]
    attributes
  end
  
  def address_attributes
    address_attributes = @params[:address].andand.slice(:street1, :street2, :city, :state, :postal_code, :country_id)
    address_attributes.andand.merge(label: :HOME, is_primary: true)
  end
  
end
