require 'pathname'
require 'lesson1/config'
require 'lesson1/application'

module Lesson1
  # Load configuration
  #
  def self.config
    @config ||= Config.new(root_path.join('config', 'rfid.yml'))
  end
  
  # Rfid.root_path.join('..')
  #
  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end
end
