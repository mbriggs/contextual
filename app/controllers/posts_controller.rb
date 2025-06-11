class PostsController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, except: [:index, :show]

  def index
    @posts = Post.published.recent
  end

  def show
    # Public posts show published posts only
    # Admin users can see drafts too
    unless @post.published? || admin_signed_in?
      redirect_to posts_path, alert: "Post not found."
      return
    end
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "Post was successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :status, :excerpt)
  end
end
