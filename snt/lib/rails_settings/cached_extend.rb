# Adds caching capabilities to the rails-settings-cached gem for model-specific settings
module RailsSettings
  module CachedExtend
    extend RailsSettings::Extend

    def settings
      CachedScopedSettings.for_thing(self)
    end
  end
end
