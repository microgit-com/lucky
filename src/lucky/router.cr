# :nodoc:
class Lucky::Router
  INSTANCE = new

  getter :routes

  def initialize
    @matcher = Amber::Router::RouteSet(Lucky::Action.class).new
    @routes = [] of Lucky::Route
  end

  def self.add(method, path, action) : Nil
    INSTANCE.add(method, path, action)
  end

  def self.routes : Array(Lucky::Route)
    INSTANCE.routes
  end

  def add(method, path, action) : Nil
    route = Lucky::Route.new(method, path, action)
    @routes << route
    @matcher.add(Lucky::Router.build_node(method, path), route.action)
  end

  def find_action(method, path)
    @matcher.find Lucky::Router.build_node(method.to_s.downcase, path)
  end

  def self.build_node(http_verb : Symbol | String, resource : String)
    "#{http_verb.to_s.downcase}#{resource}"
  end

  def self.find_action(method, path)
    INSTANCE.find_action(method, path)
  end

  def self.find_action(request) : Amber::Router::RoutedResult(Lucky::Action.class)?
    INSTANCE.find_action(request.method, request.path)
  end
end
