require 'action_dispatch/middleware/remote_ip.rb'

module API
  module Version1
    autoload :Helpers, 'version1/resources/helpers'
    autoload :Posts, 'version1/resources/posts'
    autoload :Tags, 'version1/resources/tags'

    class Engine < ::Grape::API
      format :json
      default_format :json
      default_error_formatter :json
      content_type :json, "application/json"
      version 'v1', using: :path

      use ActionDispatch::RemoteIp

      helpers API::Version1::Helpers

      mount API::Version1::Posts
      mount API::Version1::Tags
      
      add_swagger_documentation base_path: "/api", hide_documentation_path: true, api_version: "v1"

      get "/" do
        {:timenow => Time.zone.now.to_i }
      end
    end
  end
end