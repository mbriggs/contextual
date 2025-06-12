require "test_helper"

module Admin
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @post = posts(:one)
      @admin_user = users(:one)
      @commenter_user = users(:two)
    end

    # Authentication tests
    test "should require admin for all actions" do
      get admin_posts_url

      assert_redirected_to new_session_path

      get admin_post_url(@post)

      assert_redirected_to new_session_path

      get new_admin_post_url

      assert_redirected_to new_session_path

      get edit_admin_post_url(@post)

      assert_redirected_to new_session_path

      post admin_posts_url, params: { post: { title: "Test", content: "Content", status: "draft" } }

      assert_redirected_to new_session_path

      patch admin_post_url(@post), params: { post: { title: "Updated" } }

      assert_redirected_to new_session_path

      delete admin_post_url(@post)

      assert_redirected_to new_session_path
    end

    # Admin access tests
    test "admin should get index with all posts" do
      sign_in_as(@admin_user)
      get admin_posts_url

      assert_response :success
    end

    test "admin should show any post including drafts" do
      sign_in_as(@admin_user)
      @post.update_column(:status, "draft")
      get admin_post_url(@post)

      assert_response :success
    end

    test "admin should get new" do
      sign_in_as(@admin_user)
      get new_admin_post_url

      assert_response :success
    end

    test "admin should create post" do
      sign_in_as(@admin_user)
      assert_difference("Post.count") do
        post admin_posts_url, params: { post: { title: "New Post", content: "Content", status: "draft" } }
      end

      assert_redirected_to admin_post_url(Post.last)
      assert flash[:notice].include?("successfully created")
    end

    test "admin should get edit" do
      sign_in_as(@admin_user)
      get edit_admin_post_url(@post)

      assert_response :success
    end

    test "admin should update post" do
      sign_in_as(@admin_user)
      patch admin_post_url(@post), params: { post: { title: "Updated Title", content: "Updated content" } }

      assert_redirected_to admin_post_url(@post)
      assert flash[:notice].include?("successfully updated")
    end

    test "admin should destroy post" do
      sign_in_as(@admin_user)
      assert_difference("Post.count", -1) do
        delete admin_post_url(@post)
      end

      assert_redirected_to admin_posts_url
      assert flash[:notice].include?("successfully deleted")
    end

    # Validation tests
    test "should not create post without title" do
      sign_in_as(@admin_user)
      assert_no_difference("Post.count") do
        post admin_posts_url, params: { post: { content: "Content", status: "draft" } }
      end
      assert_response :unprocessable_entity
    end

    test "should not create post without content" do
      sign_in_as(@admin_user)
      assert_no_difference("Post.count") do
        post admin_posts_url, params: { post: { title: "Title", status: "draft" } }
      end
      assert_response :unprocessable_entity
    end

    test "should not update post with invalid data" do
      sign_in_as(@admin_user)
      patch admin_post_url(@post), params: { post: { title: "", content: "" } }

      assert_response :unprocessable_entity
    end

    # Non-admin access tests
    test "commenter should not access any admin action" do
      sign_in_as(@commenter_user)

      get admin_posts_url

      assert_redirected_to root_path
      assert flash[:alert].include?("Admin privileges required")

      get new_admin_post_url

      assert_redirected_to root_path

      assert_no_difference("Post.count") do
        post admin_posts_url, params: { post: { title: "New Post", content: "Content", status: "draft" } }
      end
      assert_redirected_to root_path

      get edit_admin_post_url(@post)

      assert_redirected_to root_path

      patch admin_post_url(@post), params: { post: { title: "Updated Title" } }

      assert_redirected_to root_path

      assert_no_difference("Post.count") do
        delete admin_post_url(@post)
      end
      assert_redirected_to root_path
    end
  end
end
