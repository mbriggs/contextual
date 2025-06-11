require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "get new shows password reset form" do
    get new_password_path

    assert_response :success
    assert_select "form[action=?]", passwords_path
  end

  test "post create sends password reset email" do
    user = users(:one)

    assert_emails 1 do
      post passwords_path, params: {
        email_address: user.email_address,
      }
    end

    assert_redirected_to new_session_path
  end

  test "post create with invalid email still redirects" do
    assert_emails 0 do
      post passwords_path, params: {
        email_address: "nonexistent@example.com",
      }
    end

    assert_redirected_to new_session_path
  end

  test "get edit with invalid token redirects" do
    get edit_password_path("invalid-token")

    assert_redirected_to new_password_path
    assert_equal "Password reset link is invalid or has expired.", flash[:alert]
  end
end
