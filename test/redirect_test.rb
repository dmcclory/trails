require_relative 'helper'

class BarsController < Trails::Controller
  include Trails::Renderer

  def index(*)
    render text: "Redirected, fool!"
  end

  def show(env)
    redirect_to "/bars"
  end
end

class RedirectionTests < MiniTest::Test
  include Rack::Test::Methods

  def app
    router = Trails::Router.new

    router.draw do |config|
      config.resources :bars
    end

    router
  end

  def test_redirect_returns_http_redirect_responses
    get '/bars/123'
    assert last_response.ok?
    assert_match /\/bars$/, last_response.headers["LOCATION"]

  end
end
