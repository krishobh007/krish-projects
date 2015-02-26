class Guest::TermsConditionsController < ApplicationController
  before_filter :check_consumer_key

  # Retreving All formatted terms & conditions for Mobile device.
  def get_terms_conditions
    chain_code = params[:chain_code]
    hotel_id = params[:hotel_id]

    privacy_policy = ''
    errors = []

    if hotel_id.present?
      hotel = Hotel.find(hotel_id)
      chain = hotel.hotel_chain
    elsif chain_code.present?
      chain = HotelChain.find_by_code(chain_code)
    else
      errors << I18n.t(:hotel_id_or_chain_code_required)
    end

    privacy_policy_string = chain.settings.privacy_policy || Setting.privacy_policy

    privacy_policy = privacy_policy_string.gsub('$hotel_phone', chain.settings.terms_conditions_phone.to_s)
      .gsub('$hotel_email', chain.settings.terms_conditions_email.to_s)

    if errors.empty?
      render json: { data: { privacy_policy: privacy_policy }, status: SUCCESS, errors: [] }
    else
      logger.debug "Terms And Conditions API invalid #{errors}"
      render json: { data: {}, status: FAILURE, errors: errors }
    end
  end
end
