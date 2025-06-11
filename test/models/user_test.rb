require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user requires email address and password" do
    user = User.new

    assert_requires(user, :email_address, :password)
  end

  test "email address must be unique" do
    existing_user = users(:one)
    new_user = User.new(
      email_address: existing_user.email_address,
      password: "password123",
    )

    refute new_user.valid?, "User should be invalid with duplicate email"
    assert new_user.errors[:email_address].any?, "Email uniqueness error should be present"
  end

  test "email address must be valid format" do
    user = User.new(password: "password123")

    assert_invalid_format(user, :email_address, "invalid-email", "valid@example.com")
  end

  test "password must be present" do
    user = User.new(email_address: "test@example.com")

    refute user.valid?, "User should be invalid without password"
    assert user.errors[:password].any?, "Password error should be present"
  end

  test "authenticate_by finds user with correct credentials" do
    user = users(:one)

    found_user = User.authenticate_by(
      email_address: user.email_address,
      password: "password",
    )

    assert found_user == user, "Should find user with correct credentials"
  end

  test "authenticate_by returns nil with incorrect credentials" do
    user = users(:one)

    found_user = User.authenticate_by(
      email_address: user.email_address,
      password: "wrong-password",
    )

    assert found_user.nil?, "Should return nil with incorrect password"

    found_user = User.authenticate_by(
      email_address: "wrong@example.com",
      password: "password",
    )

    assert found_user.nil?, "Should return nil with incorrect email"
  end

  test "user has many sessions and comments" do
    user = users(:one)

    assert user.respond_to?(:sessions), "User should have sessions association"
    assert user.sessions.is_a?(ActiveRecord::Associations::CollectionProxy), "Sessions should be a collection"
    assert user.respond_to?(:comments), "User should have comments association"
    assert user.comments.is_a?(ActiveRecord::Associations::CollectionProxy), "Comments should be a collection"
  end

  test "user role enum works correctly" do
    admin_user = users(:one)
    commenter_user = users(:two)

    assert admin_user.admin?, "Admin user should be admin"
    refute admin_user.commenter?, "Admin user should not be commenter"

    assert commenter_user.commenter?, "Commenter user should be commenter"
    refute commenter_user.admin?, "Commenter user should not be admin"
  end

  test "user role scopes work correctly" do
    admin_user = users(:one)
    commenter_user = users(:two)

    assert_scope_filters User.admins, admin_user, commenter_user
    assert_scope_filters User.commenters, commenter_user, admin_user
  end

  test "user defaults to commenter role" do
    user = User.new(
      email_address: "newuser@example.com",
      password: "password123",
    )

    assert user.commenter?, "New user should default to commenter role"
    refute user.admin?, "New user should not be admin by default"
  end
end
