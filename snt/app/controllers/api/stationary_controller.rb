class Api::StationaryController < ApplicationController
  def index

    @guest_bill_print_setting = current_hotel.guest_bill_print_setting
    @hotel_logo_types = Setting.hotel_logo_types
    @confirmation_template_text = current_hotel.settings.confirmation_template_text
    @location_image = @guest_bill_print_setting.present? && @guest_bill_print_setting.location_image ? @guest_bill_print_setting.location_image.image.url : ""
  end

  def save
    puts params.to_yaml
    guest_bill_print_setting = GuestBillPrintSetting.find_or_initialize_by_hotel_id(current_hotel.id)
    guest_bill_print_setting.attributes = guest_bill_print_setting_attributes
    if params[:location_image].present?
      if params[:location_image] != "false"
        guest_bill_print_setting.set_location_image(params[:location_image])
      else
        guest_bill_print_setting.location_image.destroy if guest_bill_print_setting.location_image
      end
    end
    guest_bill_print_setting.save
    current_hotel.settings.confirmation_template_text = params[:confirmation_template_text] if params.key?(:confirmation_template_text)
    
    current_hotel.settings.cancellation_communication_title = params[:cancellation_communication_title] || ""
    current_hotel.settings.cancellation_communication_text  = params[:cancellation_communication_text] || ""
  end
  
  private

  def guest_bill_print_setting_attributes
    setting_attributes = {}
    setting_attributes[:logo_type] = params[:logo_type] if params.key?(:logo_type)
    #setting_attributes[:image_file_name] = params[:location_image] if params.key?(:location_image) && params[:location_image] !=""
    setting_attributes[:show_hotel_address] = params[:show_hotel_address] if params.key?(:show_hotel_address)
    setting_attributes[:custom_text_header] = params[:custom_text_header] if params.key?(:custom_text_header)
    setting_attributes[:custom_text_footer] = params[:custom_text_footer] if params.key?(:custom_text_footer)
    setting_attributes
  end

end
