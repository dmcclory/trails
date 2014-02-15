require_relative 'helper'

Trails::Templates.register "foos#show", "<%= @name %>'s Ninja Template"

Trails::Templates.register "foos#index", """<% @entries.each_with_index do |entry, index| %><%= index.to_s + ': ' + entry + '\n' %><% end %>"""

class FoosController < Trails::Controller
  include Trails::Renderer

  def index(env)
    @entries = ["amaze", "wow", "doge"]
    render template: 'index'
  end

  def show(env)
    @name = params[:id]
    render template: 'show'
  end
end

class FooAppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    router = Trails::Router.new

    router.draw do |config|
      config.resources :foos
    end

    router
  end

  def test_render_name_builds_erb_template
    get '/foos/dave'
    assert last_response.ok?
    assert_match /dave's Ninja Template/, last_response.body
  end

  def test_render_index_builds_erb_template
    get '/foos'
    assert last_response.ok?
    assert_match /2: doge/, last_response.body
  end
end
