module Trails
  module Renderer

    def self.included(klass)
      [:status, :headers, :body].each do |method|
        unless klass.instance_methods.include? method
          raise NoMethodError method
        end
      end
    end

    def render(options={})
      @render_called = true
      if options[:json]
        headers['Content-Type'] = 'application/json'
        self.body = options[:json].to_json
      elsif options[:text]
        # since String implements each, is it fair to just return a string?
        self.body = Array( options[:text])
      elsif options[:template]
        self.body = render_body(options)
      end
    end

    def redirect_to(path)
      @render_called = true
      self.headers['Location'] = path
      self.status = 302
    end

    def render_body(options)
      template = ERB.new( template_for(options[:template]) )
      template.result(binding)
    end

    def template_for(template_name)
      name = template_name =~ /#/ ? template_name : "#{resource_name}##{template_name}"
      Templates.fetch(name)
    end

    def render_called?
      @render_called
    end
  end
end
