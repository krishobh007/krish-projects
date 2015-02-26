class ArDetail < ActiveRecord::Base
  attr_accessible :contact_first_name, :contact_last_name, :job_title, :ar_number, :address_attributes,
                  :email_attributes, :phone_attributes, :is_use_main_contact, :is_use_main_address


  has_one :address, class_name: 'Address', as: :associated_address
  has_one :email, class_name: 'AdditionalContact', as: :associated_address, conditions: { contact_type_id: Ref::ContactType[:EMAIL] }
  has_one :phone, class_name: 'AdditionalContact', as: :associated_address, conditions: { contact_type_id: Ref::ContactType[:PHONE] }

  has_many :notes, class_name: 'Note', as: :associated, dependent: :destroy
  validates_uniqueness_of :ar_number
  validates_presence_of :ar_number

  accepts_nested_attributes_for :address, :email, :phone,  allow_destroy: true, update_only: true


  def save_ar_details(params)
    attributes = {
  	  address_attributes: {},
      }

    [:street1, :street2, :street3, :city, :state, :country_id, :postal_code].each do |key|
      attributes[:address_attributes][key] = params[:ar_address_details][key] if params[:ar_address_details] && params[:ar_address_details].key?(key)
    end
    attributes[:address_attributes][:label] = :BUSINESS
    [:contact_first_name, :contact_last_name, :job_title, :ar_number].each do |key|
      attributes[key]= params[:ar_contact_details][key] if params[:ar_contact_details] && params[:ar_contact_details].key?(key)
    end
    [:is_use_main_contact, :is_use_main_address, :ar_number].each do |key|
      attributes[key]= params[key] if  params.key?(key)
    end
    attributes[:phone_attributes] = { contact_type: :PHONE, value: params[:ar_contact_details][:phone], label:Ref::ContactLabel[:HOME], is_primary: true } if params[:ar_contact_details] && params[:ar_contact_details][:phone]
    attributes[:email_attributes] = { contact_type: :EMAIL, value: params[:ar_contact_details][:email], label: Ref::ContactLabel[:HOME], is_primary: true } if params[:ar_contact_details] && params[:ar_contact_details][:email]
    update_attributes(attributes)
  end

end
