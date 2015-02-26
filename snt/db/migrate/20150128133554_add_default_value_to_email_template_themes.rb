class AddDefaultValueToEmailTemplateThemes < ActiveRecord::Migration
  def change
  	execute("update email_template_themes set is_system_specific=false where is_system_specific is null")
    change_column :email_template_themes, :is_system_specific, :boolean, null: false, default: false
  end
end
