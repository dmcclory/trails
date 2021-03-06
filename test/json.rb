require_relative 'helper'

class JsonsController < Trails::Controller

  def index
    @foo = [1, 2, 3]
    render json: @foo
  end
end

class JsonRenderTest < Minitest::Test
  include Rack::Test::Methods

  def app
    router = Trails::Router.new

    router.draw do |config|
      config.resources :jsons
    end

    router
  end

  def test_jsons_path_returns_a_json_object
    get '/jsons'
    assert last_response.ok?
    assert last_response.header['Content-type'] == "application/json"
    json_result = JSON.parse(last_response.body)
    assert_equal [1, 2, 3], json_result
  end
end
