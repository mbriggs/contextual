class PostsController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  def index
    @posts = Post.published.recent
  end

  def show
    @post = Post.find(params[:id])
    # Public posts show published posts only
    if !@post.published?
      redirect_to posts_path, alert: "Post not found."
      return
    end
  end
end
