require "rubygems"
require "bundler"

Bundler.setup

require "rack"

module Lesson0
  class SomeMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      env['test'] = 'Hello'

      if env['QUERY_STRING'] == ''
        [403, {"Content-Type" => 'text/html'}, ["Ban"]]
      else
        @app.call(env)
      end
    end
  end

  class Server
    def call(env)
      request = Rack::Request.new(env)
      [200, {"Lesson" => Time.now.to_s, "Content-Type" => 'text/html'}, [env.inspect]]
    end
  end
end