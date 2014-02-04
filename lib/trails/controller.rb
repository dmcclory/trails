module Trails
  class Controller

    include ResponseAttrs
    include Renderer

    attr_accessor :actions
    attr_accessor :params

    def initialize
      @actions = {}
      self.class.public_instance_methods.each do |action|
        @actions[action] = build_rack_app(action)
      end
    end

    def rack_app action
      @actions[action]
    end

    def resource_name
      self.class.resource_name
    end

    def self.resource_name
      name.to_s.gsub(/Controller/, "").downcase
    end

    private
    def build_rack_app(action)
      lambda { |*args|
        @params = IndifferentAccessHash.build_from_hash(args.first)
        send(action, *args)
        [status, headers, body]
      }
    end
  end
end
