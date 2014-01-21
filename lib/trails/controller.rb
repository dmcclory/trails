module Trails
  class Controller

    include ResponseAttrs
    include Renderer

    attr_accessor :actions

    def initialize
      @actions = {}
      self.class.public_instance_methods.each do |action|
        @actions[action] = lambda { |*args|
          self.send(action, *args)
          [status, headers, body]
        }
      end
    end

    def rack_app action
      @actions[action]
    end

    def resource_name
      self.class.name.to_s.gsub(/Controller/, "").downcase
    end

  end
end
