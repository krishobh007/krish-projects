module SeedAccount
  def create_account
    hotel = Hotel.first

    Account.create(hotel_chain_id: hotel.hotel_chain.id, account_name: 'First Account',  account_type_id: Ref::AccountType.first.id, account_number: 12345)
  end
end
