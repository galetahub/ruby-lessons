$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require File.expand_path('../boot', __FILE__)

ENV['RACK_ENV'] ||= 'development'
ENV['TMPDIR'] ||= File.expand_path('../../tmp', __FILE__)

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, ENV['RACK_ENV']) if defined?(Bundler)

# Load initializers
Dir["#{File.dirname(__FILE__)}/initializers/*.rb"].sort.each do |path|
  require File.expand_path("../initializers/#{File.basename(path, '.rb')}", __FILE__)
end

require "lesson1"