module Trails
  class Controller

    attr_accessor :actions

    def initialize
      @actions = {}
      self.class.public_instance_methods.each do |action|
        @actions[action] = lambda { |*args| self.send(:action, *args) }
      end
    end

    def action_for action
      @actions[action]
    end

  end
end
