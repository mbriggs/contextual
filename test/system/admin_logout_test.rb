require "application_system_test_case"

class AdminLogoutTest < ApplicationSystemTestCase
  test "admin can log out and is actually signed out" do
    admin_user = users(:one)

    # Sign in as admin
    visit new_session_path
    fill_in "Enter your email address", with: admin_user.email_address
    fill_in "Enter your password", with: "password"
    click_button "Sign in"

    # Verify we're signed in and at admin area
    assert_text "Welcome back!"
    visit admin_root_path

    assert_current_path admin_root_path

    # Click sign out button
    click_link "Sign out"

    # Verify we're redirected to sign in page
    assert_current_path new_session_path
    assert_text "You have been signed out."

    # Verify we can't access admin area anymore
    visit admin_root_path

    assert_current_path new_session_path
  end
end
