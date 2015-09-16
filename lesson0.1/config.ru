# rackup config.ru
#
require "rack"
require ::File.expand_path('../application',  __FILE__)

app = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::ShowExceptions

  map "/contacts" do
    run ::Lesson1::EndpointContacts.new
  end

  map "/" do
    run ::Lesson1::EndpointWelcome.new
  end
end

run app