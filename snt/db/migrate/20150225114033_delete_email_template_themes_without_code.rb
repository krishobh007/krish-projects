class DeleteEmailTemplateThemesWithoutCode < ActiveRecord::Migration
  def change
  	themes = EmailTemplateTheme.where(code: "")
  	templates = EmailTemplate.where('email_template_theme_id IN (?)', themes.pluck(:id))
  	hotel_email_templates = HotelEmailTemplate.where('email_template_id in (?)', templates.pluck(:id))
  	hotel_email_templates.destroy_all
  	templates.destroy_all
  	themes.destroy_all
  end
end
