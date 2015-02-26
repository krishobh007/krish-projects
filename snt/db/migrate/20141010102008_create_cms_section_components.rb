class CreateCmsSectionComponents < ActiveRecord::Migration
  def change
    create_table :cms_section_components do |t|
      t.integer :parent_id
      t.integer :child_component_id
      t.timestamps
    end
  end
end
