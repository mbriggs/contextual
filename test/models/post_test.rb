require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "post requires title and content" do
    assert_requires Post.new, :title, :content
  end

  test "post has valid status enum" do
    post = posts(:one)
    post.title = "Test Post"
    post.content = "Test content"

    assert_enum_values post, :status, :draft, :published
  end

  test "published scope returns only published posts" do
    draft_post = posts(:one)
    published_post = posts(:two)
    draft_post.update!(title: "Draft", content: "Content", status: :draft)
    published_post.update!(title: "Published", content: "Content", status: :published)

    assert_scope_filters Post.published, published_post, draft_post
  end

  test "recent scope orders by created_at desc" do
    old_post = posts(:one)
    new_post = posts(:two)
    old_post.update!(title: "Old", content: "Content", created_at: 2.days.ago)
    new_post.update!(title: "New", content: "Content", created_at: 1.day.ago)

    result = Post.recent.to_a

    assert result.first == new_post, "Most recent post should be first"
    assert result.last == old_post, "Oldest post should be last"
  end

  test "published_at is set when status changes to published" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content", status: :draft, published_at: nil)

    assert post.published_at.nil?, "Published at should be nil for draft"

    post.update!(status: :published)

    refute post.published_at.nil?, "Published at should be set when published"
  end

  test "published_at is not overwritten if already set" do
    existing_time = 1.week.ago
    post = posts(:one)
    post.update!(title: "Test", content: "Content", status: :draft, published_at: existing_time)

    post.update!(status: :published)

    assert post.published_at == existing_time, "Existing published_at should not be overwritten"
  end

  test "destroying post removes associated comments" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    comment = comments(:one)
    comment.update!(post: post)

    post.destroy!

    refute Comment.exists?(comment.id), "Comment should be deleted when post is destroyed"
  end

  test "comment method creates new comment for post" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    user = users(:one)

    comment = post.comment(user, "Great post!")

    assert comment.persisted?, "Comment should be saved"
    assert comment.post == post, "Comment should belong to post"
    assert comment.user == user, "Comment should belong to user"
    assert comment.content == "Great post!", "Content should be set"
    refute comment.approved?, "Comment should not be approved by default"
  end
end
