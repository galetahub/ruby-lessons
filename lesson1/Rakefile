require 'rubygems'
require 'bundler/setup'
#require 'rspec/core/rake_task'

task :default => :test

task :environment do
  require File.expand_path('../config/environment', __FILE__)
end

Dir.glob('lib/tasks/*.rake').each { |r| import r }
