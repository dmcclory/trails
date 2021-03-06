require_relative 'helper'

class HellosController < Trails::Controller

  def index
    render text: "<h1>Hello World!</h1>"
    headers["Content-Type"] = "text/html"
  end

  def show
    render text: "<h1>Hello #{params[:id]}!</h1>"
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

  def test_hellos_index_path_says_hello_world
    get "/hellos"
    assert last_response.ok?
    assert_match /Hello World!/, last_response.body
  end

  def test_hellos_show_path_says_hello_user
    get "/hellos/dan"
    assert last_response.ok?
    assert_match /Hello dan!/, last_response.body
  end
end
