module Trails
  module Renderer

    def self.included(klass)
      [:status, :headers, :body].each do |method|
        unless klass.instance_methods.include? method
          raise NoMethodError method
        end
      end
    end

    def render(options)
      self.body = Array( options[:text])

    end
  end
end
