class CreateCmsComponents < ActiveRecord::Migration
  def change
    create_table :cms_components do |t|
      t.string :component_name
      t.integer :hotel_id
      t.string :component_type
      t.string :icon_file_name
      t.string :icon_content_type
      t.string :icon_file_size
      t.text :description
      t.string :address
      t.string :website_url
      t.integer :phone
      t.string :page_template
      t.string :status
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.timestamps
    end
  end
end
