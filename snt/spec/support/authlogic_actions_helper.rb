module AuthlogicActionsHelper
  # Define a method which signs in as a valid user.
  def sign_in_as_a_valid_user(user)
    # We action the login request using the parameters before we begin.
    # The login requests will match these to the user we just created in the factory, and authenticate us.
    post_via_redirect sessions_path, 'email' => user.email, 'password' => user.password, 'chain_code' => user.hotel_chain.code
  end

  def sign_in_as_a_valid_staff(user)
    # We action the login request using the parameters before we begin.
    # The login requests will match these to the user we just created in the factory, and authenticate us.
    post_via_redirect staff_sessions_path, 'email' => user.email, 'password' => user.password, 'chain_code' => user.hotel_chain.code
  end
end

RSpec.configure do |config|
# Include the help for the request specs.
  config.include AuthlogicActionsHelper, type: :request
end
