require 'pattern-match'
module Trails
  class Router

    attr_accessor :controllers
    attr_accessor :missing_resource_controller

    def initialize
      @controllers = []
    end

    def draw()
      yield(self) if block_given?
    end

    def resources(name, &block)
      resource_controller = name.capitalize.to_s + "Controller"
      controller = Module.const_get(resource_controller).new
      controllers.delete(controller)
      controllers << controller
      self.instance_eval(&block) if block_given?
    end

    def member(&block)
      self.instance_eval(&block) if block_given?
    end

    def collection(&block)
      self.instance_eval(&block) if block_given?
    end

    def put(method_name)
      controllers.first.build_app_for(method_name)
      routes.unshift( { path:/.*\/#{method_name}/, method: "PUT", action:  method_name } )
    end

    def get(method_name)
      controllers.first.build_app_for(method_name)
    end

    def call(env)
      resource, rest = split_url(env["PATH_INFO"])
      controller = controller_for(resource)
      action = action_for(rest, env["REQUEST_METHOD"])
      app = controller.action_for(action)
      app.call(env)
    end

    def controller_for(route)
      resource_name = route.split("/")[1]
      controller = self.controllers.select { |c| resource_name == c.resource_name }.first
      controller || missing_resource_controller
    end

    def action_for(segment, method="GET")
      routes.select { |r|
        r[:method] == method && r[:path] =~ segment
      }.first[:action]
    end

    private

    def routes
      @routes ||= [ { path:/\/edit/, method: "GET", action: :edit },
        { path:/\/new/, method: "GET", action:  :new },
        { path:/^$/, method: "GET", action:  :index },
        { path:/.*/, method: "GET", action: :show },
        { path:/.*/, method: "POST", action:  :create },
        { path:/.*/, method: "PUT", action: :update },
        { path:/.*/, method: "DELETE", action:  :destroy }
      ]
    end

    def split_url url
      _, prefix, rest = url.split("/", 3).map {|s| "/" + s }
      rest ||= ""
      return [prefix, rest]
    end
  end
end
