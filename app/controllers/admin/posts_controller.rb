module Admin
  class PostsController < AdminController
    def index
      @posts = Post.all.recent
    end

    def show
      @post = Post.find(params[:id])
    end

    def new
      @post = Post.new
    end

    def edit
      @post = Post.find(params[:id])
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to admin_post_path(@post), notice: "Post was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to admin_post_path(@post), notice: "Post was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post = Post.find(params[:id])
      @post.destroy!
      redirect_to admin_posts_path, notice: "Post was successfully deleted."
    end

    private def post_params
      params.require(:post).permit(:title, :content, :status, :excerpt)
    end
  end
end
