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
    - ~~ member actions ~~
    - ~~ collection actions ~~
  - ~~ `resource/:id` available in the controller as `params[:id]` ~~

- Rack/test -> integrations
  - ~~tiny.rb - demonstrates most basic functionality~~

- Templates, rendering & status codes
  - render text
  - ~~render json~~
  - render ERB template
    - ~~ with name, register templates manually ~~
    - defaults to controller/action, register templates manually
  - register views automatically
  - forms!
  - config allows different renderers

- Redirects
- Multi-word resource names

- Models
  - use ROM models

- User Experience
  - url helpers
  - autoload code
  - stack trace error page
  - command line app
    - trails server
