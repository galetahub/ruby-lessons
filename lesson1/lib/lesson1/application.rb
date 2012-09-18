module Lesson1
  class Application
    class << self
      def call(env)
        [200, {"Content-Type" => "text/html"}, ["Hello Rack!"]]
      end
    end
  end
end