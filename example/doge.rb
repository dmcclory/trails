require 'trails'

require 'rack'
require 'rack/showexceptions'

# create a normal looking Rails controller
class DogesController < Trails::Controller
  def index
    @doges = ["wowe", "such control"]
  end
end

# register templates
# use 'controller_name#action_name' as the key and pass an ERB template

Trails::Templates.register('doges#index', '<ol><% @doges.each do |doge| %> <li><%= doge %></li><% end %></ol>')

# register routes to a controller:
router = Trails::Router.new
router.draw do |config|
  config.resources :doges
end

# set up a Thin (or any other Rack server) and point it at the router
# the router is a rack app!

Rack::Server.start(
  :app => router,
  :Port => 9292
)
