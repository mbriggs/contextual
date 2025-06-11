require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "comment requires all required fields" do
    assert_requires Comment.new, :author_name, :author_email, :content, :post
  end

  test "comment validates email format" do
    comment = comments(:one)
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    comment.update!(post: post, author_name: "Test", content: "Content")

    assert_invalid_format comment, :author_email, "invalid-email", "valid@example.com"
  end

  test "comment defaults to not approved" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")

    comment = post.comment("Test Author", "test@example.com", "Test content")

    refute comment.approved?, "Comment should default to not approved"
    assert comment.approved_at.nil?, "Approved at should be nil by default"
  end

  test "approved scope returns only approved comments" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    approved_comment = comments(:one)
    pending_comment = comments(:two)
    approved_comment.update!(post: post, approved_at: Time.current)
    pending_comment.update!(post: post, approved_at: nil)

    assert_scope_filters Comment.approved, approved_comment, pending_comment
  end

  test "pending scope returns only pending comments" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    approved_comment = comments(:one)
    pending_comment = comments(:two)
    approved_comment.update!(post: post, approved_at: Time.current)
    pending_comment.update!(post: post, approved_at: nil)

    assert_scope_filters Comment.pending, pending_comment, approved_comment
  end

  test "recent scope orders by created_at desc" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    old_comment = comments(:one)
    new_comment = comments(:two)
    old_comment.update!(post: post, created_at: 2.days.ago)
    new_comment.update!(post: post, created_at: 1.day.ago)

    result = Comment.recent.to_a

    assert result.first == new_comment, "Most recent comment should be first"
    assert result.last == old_comment, "Oldest comment should be last"
  end

  test "comment belongs to post" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    comment = comments(:one)
    comment.update!(post: post)

    assert comment.post == post, "Comment should belong to assigned post"
  end

  test "approve! sets approved_at timestamp" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")

    comment = post.comment("Test Author", "test@example.com", "Test content")
    comment.approve!

    assert comment.approved?, "Comment should be approved after approve!"
    refute comment.approved_at.nil?, "Approved at should be set"
  end

  test "unapprove! clears approved_at timestamp" do
    post = posts(:one)
    post.update!(title: "Test", content: "Content")
    comment = comments(:one)
    comment.update!(post: post, approved_at: Time.current)

    comment.unapprove!

    refute comment.approved?, "Comment should not be approved after unapprove!"
    assert comment.approved_at.nil?, "Approved at should be cleared"
  end

  test "approved? returns true when approved_at is present" do
    comment = comments(:one)

    assert comment.approved?, "Comment with approved_at should be approved"
  end

  test "approved? returns false when approved_at is nil" do
    comment = comments(:two)

    refute comment.approved?, "Comment without approved_at should not be approved"
  end
end
