module Trails
  class Controller

    attr_accessor :params

    def [](method)
      lambda do |env|
        self.params = env
        self.send(:method)
      end
    end
  end
end
