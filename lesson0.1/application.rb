# application.rb
#
module Lesson1
  class EndpointContacts
    def call(env)
      [200, {'Content-Type' => 'text/plain'}, ['Contacts is here!']]
    end
  end

  class EndpointWelcome
    def call(env)
      [200, {'Content-Type' => 'text/plain'}, ['Welcome!']]
    end
  end
end