class AddSignatureToEmailTemplates < ActiveRecord::Migration
  def change
    add_column :email_templates, :signature, :text
  end
end
