class AddAttachmentTemplateLogoToHotels < ActiveRecord::Migration
  def self.up
    change_table :hotels do |t|
      t.attachment :template_logo
    end
  end

  def self.down
    drop_attached_file :hotels, :template_logo
  end
end
