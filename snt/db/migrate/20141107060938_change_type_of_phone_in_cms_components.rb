class ChangeTypeOfPhoneInCmsComponents < ActiveRecord::Migration
  def change
    change_column :cms_components, :phone, :string
  end
end
