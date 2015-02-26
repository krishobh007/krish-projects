class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :title
      t.text :subject
      t.text :body
      t.integer :hotel_id

      t.timestamps
    end
  end
end
