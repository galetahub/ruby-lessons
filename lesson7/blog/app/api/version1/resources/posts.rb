require "grape"

module API
  module Version1
    class Posts < ::Grape::API
      version 'v1', using: :path

      resource :posts do
        desc "Returns sorted posts"
        get "/" do
          Post.order(id: :desc).all
        end

        desc "Create new post", headers: {
          "X-Auth-Token" => {
            description: "User token",
            required: true
          }
        }
        params do
          group :post, type: Hash do
            requires :title, :type => String, :desc => "Title"
            requires :author_name, :type => String, :desc => "Author name"
            requires :slug, :type => String, :desc => "Slug"
            requires :content, :type => String, :desc => "Content"
            optional :tag_ids, :type => Array, :desc => "Post tags"
          end
        end
        post '/' do
          @post = Post.new

          if @post.update_attributes(params[:post])
            @post
          else
            error!({:errors => @post.errors}, 422)
          end
        end

        desc "Return post info"
        get "/:id" do
          @post = Post.find(params[:id])
          @post
        end


      end
    end
  end
end