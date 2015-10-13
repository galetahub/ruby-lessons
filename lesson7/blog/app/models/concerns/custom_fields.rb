# app/models/concerns/custom_fields.rb
#
module CustomFields
  extend ActiveSupport::Concern

  module ClassMethods
    def custom_fields(*args)
      args.each do |attribute_name|
        define_method(attribute_name) do
          custom_field_part(attribute_name)
        end

        define_method("#{attribute_name}=") do |value|
          custom_field_part(attribute_name, value)
        end
      end
    end
  end

  protected

    def custom_field_part(*args)
      key, value = args
      key = key && key.to_s
      if args.size == 1
         settings && settings[key]
      elsif args.size == 2
         raise ArgumentError, "invalid key #{key.inspect}" unless key
         settings_will_change!
         self.settings = (settings || {}).merge(key => value)
         self.settings[key]
      else raise ArgumentError, "wrong number of arguments (#{args.size} for 1 or 2)"
      end
    end
end