class SeedEmailTemplateThemesFromExistingData < ActiveRecord::Migration
  def change
  	templates = execute("SELECT hotel_id FROM email_templates")
    templates.each(:as => :hash) do |row|
      hotel_id = row["hotel_id"]
      if hotel_id
        hotel_name = ""
        results = execute("SELECT name FROM hotels where id=#{hotel_id}")
        results.each(:as => :hash) do |row|
          hotel_name = row["name"]
        end
        existing_themes = ActiveRecord::Base.connection.execute("SELECT * FROM email_template_themes where name='#{hotel_name}'")
        execute("INSERT INTO email_template_themes(is_system_specific, name) values(false, '#{hotel_name}')") if existing_themes.count == 0
	  end
    end
  end
end
