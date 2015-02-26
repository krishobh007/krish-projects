# Adds caching capabilities to the rails-settings-cached gem for model-specific settings
module RailsSettings
  class CachedScopedSettings < Settings
    after_update :rewrite_cache
    after_create :rewrite_cache

    def rewrite_cache
      Rails.cache.write("#{thing_type}:#{thing_id}:settings:#{var}", value)
    end

    after_destroy { |record| Rails.cache.delete("#{record.thing_type}:#{record.thing_id}:settings:#{record.var}") }

    def self.[](var_name)
      cache_key = "#{@object.class.base_class.to_s}:#{@object.id}:settings:#{var_name}"
      obj = Rails.cache.fetch(cache_key) do
        super(var_name)
      end
      obj == nil ? @@defaults[var_name.to_s] : obj
    end

    def self.for_thing(object)
      @object = object
      self
    end

    def self.thing_scoped
      unscoped.where(thing_type: @object.class.base_class.to_s, thing_id: @object.id)
    end
  end
end
