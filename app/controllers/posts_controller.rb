class PostsController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]
  before_action :set_post, only: [:show]

  def index
    @posts = Post.published.recent
  end

  def show
    # Public posts show published posts only
    unless @post.published?
      redirect_to posts_path, alert: "Post not found."
      return
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
