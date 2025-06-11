require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "get new shows login form" do
    get new_session_path

    assert_response :success
    assert_select "form[action=?]", session_url
  end

  test "post create with valid credentials signs in user" do
    user = users(:one)

    post session_path, params: {
      email_address: user.email_address,
      password: "password",
    }

    assert_redirected_to root_path
    assert_equal "Welcome back!", flash[:notice]
  end

  test "post create with invalid credentials shows error" do
    user = users(:one)

    post session_path, params: {
      email_address: user.email_address,
      password: "wrong-password",
    }

    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "delete destroy signs out user" do
    user = users(:one)

    # Sign in first
    post session_path, params: {
      email_address: user.email_address,
      password: "password",
    }

    delete session_path

    assert_redirected_to new_session_path
    assert_equal "You have been signed out.", flash[:notice]
  end

  test "authentication helpers work correctly after sign in" do
    user = users(:one)

    # Sign in user
    post session_path, params: {
      email_address: user.email_address,
      password: "password",
    }

    # Verify authentication status by making authenticated request
    get root_path

    assert_response :success
  end

  test "multiple failed login attempts work correctly" do
    user = users(:one)

    # Make multiple failed attempts
    5.times do
      post session_path, params: {
        email_address: user.email_address,
        password: "wrong-password",
      }

      assert_redirected_to new_session_path
      assert_equal "Try another email address or password.", flash[:alert]
    end
  end
end
