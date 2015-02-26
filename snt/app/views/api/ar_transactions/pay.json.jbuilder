json.available_credits @account.available_credits(current_hotel)
json.amount_owing @account.amount_owing(current_hotel)
json.open_guest_bills @open_count
json.errors @errors if @errors