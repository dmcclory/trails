gem 'minitest'
require 'rack/test'
require 'minitest/autorun'
require 'trails'

class HellosController < Trails::Controller
  include Trails::Renderer

  def index(env)
    render text: "<h1>Hello World!</h1>"
    headers["Content-Type"] = "text/html"
  end
end

class TinyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    router = Trails::Router.new

    router.draw do |config|
      config.resources :hellos
    end

    router
  end

  def test_hellos_path_says_hello_world
    get "/hellos"
    assert last_response.ok?
    assert_match /Hello World!/, last_response.body
  end

end
