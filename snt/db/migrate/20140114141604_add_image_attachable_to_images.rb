class AddImageAttachableToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.references :image_attachable, polymorphic: true
    end
  end
end
