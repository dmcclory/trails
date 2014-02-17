require 'trails'

class HellosController < Trails::Controller

  def index(env)
    render text: "<h1>Hello World!</h1>"
    headers["Content-Type"] = "text/html"
  end

  def show(env)
    redirect_to "/hellos"
  end
end

router = Trails::Router.new

router.draw do |config|
  config.resources :hellos
end

if $0 == __FILE__
  require 'rack'
  require 'rack/showexceptions'

  Rack::Server.start(
    :app => router,
    :Port => 9292
  )
end
