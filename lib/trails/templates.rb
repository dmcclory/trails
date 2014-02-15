module Trails
  class Templates
    @templates = {}

    def self.register(key, template)
      @templates[key] = template
    end

    def self.fetch(key)
      @templates[key]
    end
  end
end
