class Api::EmailTemplatesController < ApplicationController
  before_filter :check_session

  def list
      @hotel = Hotel.find(params[:hotel_id])
      @email_template_themes = EmailTemplateTheme.where(is_system_specific: :true)
      # Hotel's current Email Templates.
      @existing_email_templates = @hotel.email_templates
      # Hotel's Current Email Template Theme.
      @hotel_email_template_theme = @hotel.settings.theme
      @existing_email_template_theme = EmailTemplateTheme.find_by_code(@hotel_email_template_theme)
      # Email Templates corrsponding to the Existing Email Template Theme.
      @email_templates = EmailTemplate.where('email_template_theme_id = (?)',  @existing_email_template_theme.andand.id)
  end

  def assign_to_hotel
    @hotel = Hotel.find(params[:hotel_id])
    theme_code = params[:hotel_theme].present? ? EmailTemplateTheme.find(params[:hotel_theme]).andand.code : ""
    
    @hotel.settings.theme = theme_code
    if params[:templates].present?
      @hotel.hotel_email_templates.destroy_all
      new_email_templates = EmailTemplate.find(params[:templates])
      new_email_templates.each do |email_template|
        @hotel.email_templates << email_template
        @email_template = email_template
      end
    else
      @hotel.hotel_email_templates.destroy_all
    end
  end

  def email_templates
    email_template_theme = EmailTemplateTheme.find(params[:email_template_theme_id]) if params[:email_template_theme_id].present?
    @email_templates = EmailTemplate.where('email_template_theme_id = (?)',  email_template_theme)
  end
end
