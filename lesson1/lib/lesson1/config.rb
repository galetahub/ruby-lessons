require "yaml"
require "ostruct"

module Lesson1
  class Config < OpenStruct
    attr_reader :table, :filepath
    
    def initialize(filepath)
      @filepath = filepath.to_s.strip
      super(parse_file)
    end
    
    def reload!
      @table = parse_file.symbolize_keys
    end
    
    protected
      
      def parse_file
        YAML.load_file(@filepath)
      end
  end
end
