# 2014-2-15

I worked on the templates for a few hours in the afternoon. I added a Templates registry, which associates templates with keys based on `[controller_name, action_name]` tuples. (Converted to a string, delimited by a '#'). The registry pattern works well for this, because the controller/action pairs are unique & it's ok for them to be global. Eventually, I'll have the initialization look for an `app/views` directory, and then walk the file tree, read in the templates, and store them in a field based on the directory & filename. I wonder how I'll handle other renderers?

At one point, I'd forgotten that I hadn't implemented the 'render the controller/action name view by default' feature that rails provides, so I spent ~15 mins wondering why my tests weren't passing. That ended up being an easy feature to implement. I decided to go with a 'render_called' flag (after spending a bit of time trying out a solution with to extract the source from the method, and checked to see if called 'render'. I decided not to go down that route to avoid having to worry about the possiblity of a user ever creating a variable that included the string.)

The code felt pretty easy to get back into, though I found myself wishing I'd included more assertions, that I'd written it in the style of that Anders Holm course. I found myself thinking about throwing the code away and starting over. Just to see how it would feel to start over. Would it be easier? Would it be more flexible the second time? I think that it would be. I think that in general, rewriting is good.

MVP does not include multiple renderers. Nor does it include complicated string logic based on multi-word entity names. I think the important components to add now are:
  - redirects
  - forms
  - url helpers

# 2014-2-16

I added redirect. This was simple to write, but tricky to confirm that it was working. Three things combined to make it hard to tell what was happening:

1. the browser automatically requests `favicon.ico` when it loads a page. Since the server didn't have anything defined, an exception made it to Thin. It made it look like one of the requests had failed (either the original or the redirect request).

2. I couldn't remember how to get a tool to give me the complete HTTP response. I tried out telnet, curl, wget, and the Http gem, but I kept jumping around too quickly. `curl -i url` provides the entire response - the status line, headers, and body.

3. My code didn't set the status code to something in the 300 range. So the browser didn't trigger a redirect. I set the status code, and it worked! Default is 302, temporary redirect, which is Rails' default.

So my I thought my code had a broken route, but really it just needed to have a status code set.

I looked at the documentation and saw. That there were many more possible render variants, so I added them to the list. For the redirect_to feature to work well, it kind of screams for the path helpers. So I played around with the inflector api. I don't really want to add them. So I find myself wondering what I'm working on this for? Who for? When is it done?
  - when it's a fucking clone of rails
  - when I've given a presentation on it
  - right now.

At this point, I've written code that takes the Rack ENV, passes it to the appropriate controller, and is able to render ERB templates. That is ... a tiny clone of rails. I used Rspec to test drive it.

I think that the meta goals, getting feedback on it, rewriting it, or presenting on it. Are what I should do next.
