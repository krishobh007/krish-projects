class AddDomainNameToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :domain_name, :string
  end
end
