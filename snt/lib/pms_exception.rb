module PmsException
  class PmsError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class InvalidUserError < PmsError
    def initialize
      super(I18n.t(:invalid_user))
    end
  end

  class InvalidParametersError < PmsError
    def initialize
      super(I18n.t(:invalid_parameters))
    end
  end

  class SocialLobbyStatusMissingError < PmsError
    def initialize
      super(I18n.t(:lobby_status_missing))
    end
  end

  class ExternalPmsError < PmsError
    def initialize
      super(I18n.t('exception.external_pms'))
    end
  end

  class InvalidReservationError < PmsError
    def initialize(message)
      super(I18n.t(:invalid_reservation))
    end
  end


end
