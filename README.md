##  Hello
This is a Rails clone. It's not intended to be feature complete. Instead, it's intended to be a learning project, both for us, the builders, but also for any readers. The code intended to model what Rails does. (We're aware of Noah Gibb's Rebuilding Rails book, but some times it's more useful to build it for yourself)

We use elements from the Rails ecosystem where appropriate (Thor, Bundler, Better Errors)

## Feature Roadmap:

- Router & Controller
  - ~~ router creates REST resources for a controller ~~
    - ~~ index, show, create, update, new, edit, destroy ~~
    - ~~ router instantiates a new controller for each request ~~
    - router supports `only` param
  - ~~ Controller.rack_app() returns a rack app which executes a controller action ~~
  - router supports custom mappings
    - ~~ :member actions ~~
    - ~~ collection actions ~~
  - ~~ `resource/:id` available in the controller as `params[:id]` ~~

- Rack/test -> integrations
  - ~~tiny.rb - demonstrates most basic functionality~~

- Templates, rendering & status codes
  - render text
  - ~~render json~~
  - render ERB template
    - ~~ with name, register templates manually ~~
    - ~~ defaults to controller/action, register templates manually ~~
    - render nothing: true
    - render file: '/...' (takes an absolute path)
    - render has string/symbol indifference
    - render action: X is the same as render X
    - render inline template
    - render xml
    - render js
  - render options
    - layout specifies a layout
      - a lot of stuff [here](http://guides.rubyonrails.org/layouts_and_rendering.html#using-render) and [here](http://guides.rubyonrails.org/layouts_and_rendering.html#structuring-layouts) on how layouts work.
    - content_type sets the content type header
    - status sets the status code
    - location sets the Location header

  - register views automatically

- ~~Redirects~~

- url helpers

- Multi-word resource names
- config allows different renderers (haml, slim)
- forms!

- Models
  - use ROM models

- User Experience
  - autoload code
  - stack trace error page
  - command line app
    - trails server
