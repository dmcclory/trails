require 'pattern-match'
module Trails
  class Router

    attr_accessor :controllers
    attr_accessor :missing_resource_controller

    def call(env)
      resource, rest = split_url(env["PATH_INFO"])
      controller = controller_for(resource)
      action = action_for(rest, env["REQUEST_METHOD"])
      app = controller.action(action)
      app.call(env)
    end

    def controller_for(route)
      resource_name = route.split("/")[1].capitalize
      controller = self.controllers.select { |c| /#{resource_name}Controller/ =~ c.class.name }.first
      controller || missing_resource_controller
    end

    def action_for(segment, method="GET")
      match ([segment, method]) do
        with(_["", "GET"]) { :index }
        with(_["/new", "GET"]) { :new }
        with(_["", "POST"]) { :create }
        with(_[seg, "GET"], guard { seg.count("/") == 1 }) { :show }
        with(_[seg, "GET"], guard { seg =~ /.*\/edit/ }) { :edit }
        with(_[_, "PUT"] ) { :update }
        with(_[_, "DELETE"]) { :destroy }
      end
    end

    def split_url url
      _, prefix, rest = url.split("/", 3).map {|s| "/" + s }
      rest ||= ""
      return [prefix, rest]
    end
  end
end
