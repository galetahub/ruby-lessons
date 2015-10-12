class TagsController < ApplicationController
  before_action :find_tag

  def show
    @articles = ContentView.any_tags(@tag.id).recently.page(params[:page]).per(3)
  end

  protected

    def find_tag
      @tag = Tag.where(slug: params[:id]).first
      raise ActiveRecord::RecordNotFound.new("Tag by #{params[:id]} not found") if @tag.nil?
    end
end
