class AddDomainNameToHotelChains < ActiveRecord::Migration
  def change
    add_column :hotel_chains, :domain_name, :string
  end
end
