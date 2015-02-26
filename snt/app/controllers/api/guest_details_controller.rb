class Api::GuestDetailsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  before_filter :retrieve, only: [:show, :update]

  def index
    @guest_details = current_hotel.hotel_chain.guest_details
      .joins('LEFT OUTER JOIN addresses on addresses.associated_address_id = guest_details.id and addresses.associated_address_type = "GuestDetail"')
      .joins('LEFT OUTER JOIN additional_contacts on additional_contacts.associated_address_id = guest_details.id and  additional_contacts.associated_address_type = "GuestDetail" and contact_type_id=1 and additional_contacts.is_primary=1')
      .joins('LEFT OUTER JOIN guest_memberships on guest_memberships.guest_detail_id = guest_details.id').uniq

    scope_params(params).each do |key, value|
      @guest_details = @guest_details.public_send(key, value) if value.present?
    end

    @guest_details = @guest_details.page(params[:page]).per(params[:per_page])
  end

  def show
    @guest_detail = GuestDetail.find(params[:id])
  end

  def create
    GuestDetail.transaction do
      @guest_detail = current_hotel.hotel_chain.guest_details.create!(guest_attributes)
      save_associations!
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  def update
    GuestDetail.transaction do
      save_associations!
      if current_hotel && current_hotel.is_third_party_pms_configured?
        if @guest_detail.external_id
          guest_api = GuestApi.new(current_hotel.id)
          @guest_detail.attributes  = guest_attributes
          guest_api.update_guest(@guest_detail.external_id , @guest_detail)
        end
      end
      @guest_detail.update_attributes!(guest_attributes)
     end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  private

  def retrieve
    @guest_detail = GuestDetail.find(params[:id])
  end

  # Sending scope param and request param are same.
  def scope_params(params)
    params.slice(:first_name, :last_name, :city, :membership_no, :email)
  end

  def guest_attributes
    attributes = params.slice(:title, :first_name, :last_name, :job_title, :works_at, :is_opted_promotion_email)
    attributes[:is_vip] = params[:vip]
    attributes[:birthday] = Date.strptime(params[:birthday], '%m-%d-%Y') if params[:birthday]
    attributes
  end

  def save_associations!
    save_email! if params.key?(:email)
    save_phone! if params.key?(:phone)
    save_mobile! if params.key?(:mobile)
    save_address! if params.key?(:address)
  end

  def save_email!
    email = @guest_detail.emails.primary.first

    if params[:email].present?
      if email
        email.update_attributes!(value: params[:email])
      else
        @guest_detail.contacts.create!(value: params[:email], contact_type: :EMAIL, label: :HOME, is_primary: true)
      end
    elsif email
      email.destroy
    end
  end

  def save_phone!
    phone = @guest_detail.phones.home.first

    if params[:phone].present?
      if phone
        phone.update_attributes!(value: params[:phone])
      else
        @guest_detail.contacts.create!(value: params[:phone], contact_type: :PHONE, label: :HOME, is_primary: false)
      end
    elsif phone
      phone.destroy
    end
  end

  def save_mobile!
    mobile = @guest_detail.phones.mobile.first

    if params[:mobile].present?
      if mobile
        mobile.update_attributes!(value: params[:mobile])
      else
        @guest_detail.contacts.create!(value: params[:mobile], contact_type: :PHONE, label: :MOBILE, is_primary: false)
      end
    elsif mobile
      mobile.destroy
    end
  end

  def save_address!
    address = @guest_detail.addresses.primary.first

    if params[:address].present?
      if address
        address.update_attributes!(address_attributes)
      else
        @guest_detail.addresses.create!(address_attributes)
      end
    end
  end

  def address_attributes
    attributes = params[:address].andand.slice(:street1, :street2, :city, :state, :postal_code, :country_id)
    attributes.andand.merge(label: :HOME, is_primary: true)
  end
end
