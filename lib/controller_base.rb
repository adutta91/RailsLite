require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params)
    @res = res
    @req = req
    @params = route_params
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    # raises an error if a response is already created
    raise "double render error" if already_built_response?

    # sets the status to a 3xx code, given that it's a redirect (convention?)
    @res.status = 302

    # sets the response redirect location to the given url
    @res['location'] = url

    # updates the session cookie with the result
    @session.store_session(@res)

    # sets the instance variable to true, so another response will raise
    # an exception
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    # raises an error if a response is already created
    raise "double render error" if already_built_response?

    # sets the response's content type to the given type
    @res['Content-Type'] = content_type

    # populates the body of the response
    @res.write(content)

    # updates the session cookie with the result
    @session.store_session(@res)

    # sets the instance variable to true, so another response will raise
    # an exception
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    # finds controller name
    controller_name = self.class.to_s.underscore

    # finds path to file, following a convention
    path = "views/#{controller_name}/#{template_name.to_s}.html.erb"

    # reads content of file
    template = File.read(path)

    # evaluates ERB components of the template
    #   'binding' allows use of instance variables within the ERB
    contents = ERB.new(template).result(binding)

    # calls render on the resulting template, given fixed text/html format
    render_content(contents, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
