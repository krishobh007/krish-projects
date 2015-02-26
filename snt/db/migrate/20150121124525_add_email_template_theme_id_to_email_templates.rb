class AddEmailTemplateThemeIdToEmailTemplates < ActiveRecord::Migration
  def change
    add_column :email_templates, :email_template_theme_id, :integer
  end
end
