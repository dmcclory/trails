##  Hello
This is a Rails clone. It's not intended to be feature complete. Instead, it's intended to be a learning project, both for us, the builders, but also for any readers. The code intended to model what Rails does. (We're aware of Noah Gibb's Rebuilding Rails book, but some times it's more useful to build it for yourself)

We use elements from the Rails ecosystem where appropriate (Thor, Bundler, Better Errors)

## Feature Roadmap:

- Router & Controller
  - ~~ router creates REST resources for a controller ~~
    - ~~ index, show, create, update, new, edit, destroy ~~
    - ~~ router instantiates a new controller for each request ~~
    - router supports `only` param
  - ~~ Controller.action() returns a rack app which executes a controller action ~~
  - router supports custom mappings
    - ~~ member actions ~~
    - collection actions


- Templates
  - render ERB template
  - config allows different renderers

- Models
  - use ROM models

- User Experience
  - autoload code
  - stack trace error page
  - command line app
    - trails server
  - url helpers

