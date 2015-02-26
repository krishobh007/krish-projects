class AddCodeToEmailTemplateThemes < ActiveRecord::Migration
  def change
  	add_column :email_template_themes, :code, :string, null: false
  end
end
