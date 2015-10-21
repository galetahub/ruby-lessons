require "grape"

module API
  module Version1
    class Tags < ::Grape::API
      version 'v1', using: :path

      resource :tags do
        desc "Returns sorted tags"
        get "/" do
          Tag.order(id: :desc).all
        end
      end
    end
  end
end