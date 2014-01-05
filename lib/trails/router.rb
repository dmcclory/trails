module Trails
  class Router

    def initialize
      @resources = {}
      yield(self) if block_given?
    end

    def resource type
      route = /$\/#{type.to_s.downcase}/
      controller
      @resources[route] = controller_for type
    end

    def controller_for type
      noun = type.to_string.capitalize
      controller_name = noun + "Controller"
      begin
        controller = Module.const_get controller_name
        return controller.new
      rescue
        NotImplementedError "no implementation for: #{controller_name}"
      end
    end

    def call(env)
      @resources.each do |prefix, controller|
        if prefix =~ env["PATH_INFO"]
          action, id = method_for(env["PATH_INFO"], prefix)
          env[":id"] = id
          return controller[action].call(env)
        end
      end

      render :missing_resource
    end

    def method_for(path, prefix)
      _, id = path.split(prefix)
      if id.nil?
        return :index
      else
        return :show, :id
      end
    end
  end
end
