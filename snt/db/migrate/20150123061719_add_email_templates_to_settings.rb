class AddEmailTemplatesToSettings < ActiveRecord::Migration
  def change
    hotel_list = Hotel.all
    hotel_list.each do |hotel|
      email_template_theme_id = hotel.email_templates.first.andand.email_template_theme_id
      if email_template_theme_id
        theme_name = EmailTemplateTheme.find(email_template_theme_id).name
        hotel.settings.email_template_theme = theme_name
      end
    end
  end
end
