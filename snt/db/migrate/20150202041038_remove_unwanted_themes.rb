class RemoveUnwantedThemes < ActiveRecord::Migration
  def change
  	execute("DELETE FROM email_template_themes WHERE id NOT IN (SELECT email_template_theme_id from email_templates)")
  end
end
