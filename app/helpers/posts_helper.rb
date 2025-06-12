module PostsHelper
  def post_status_classes(post)
    if post.published?
      "bg-green-100 text-green-800"
    else
      "bg-yellow-100 text-yellow-800"
    end
  end
end
