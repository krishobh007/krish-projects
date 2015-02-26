class MoveExistingEmailTemplateAssociationToNewTable < ActiveRecord::Migration
  def change
  	templates = execute("SELECT id, hotel_id FROM email_templates")
  	templates.each(:as => :hash) do |row|
  	  template_id = row["id"]
      hotel_id = row["hotel_id"]
      if hotel_id
        hotel_name = ""
        results = execute("SELECT name FROM hotels where id=#{hotel_id}")
        results.each(:as => :hash) do |row|
          hotel_name = row["name"]
        end
        existing_themes = ActiveRecord::Base.connection.execute("SELECT id FROM email_template_themes where name='#{hotel_name}'")
        execute("INSERT INTO email_template_themes(is_system_specific, name) values(false, '#{hotel_name}')") if existing_themes.count == 0
        existing_themes = ActiveRecord::Base.connection.execute("SELECT id FROM email_template_themes where name='#{hotel_name}'")
        theme_id = nil
        existing_themes.each(:as => :hash) do |row|
          theme_id = row["id"]
        end
        execute("INSERT INTO hotel_email_templates(email_template_id, hotel_id) values(#{template_id}, '#{hotel_id}')")
        execute("UPDATE email_templates SET email_template_theme_id=#{theme_id} WHERE id=#{template_id}") if theme_id
	  end
    end
  end
end
