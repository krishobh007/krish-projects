class CreateEmailTemplateThemes < ActiveRecord::Migration
  def change
    create_table :email_template_themes do |t|
      t.boolean :is_system_specific
      t.string :name
      t.timestamps
    end
    add_index :email_template_themes, :name, unique: true
  end
end
