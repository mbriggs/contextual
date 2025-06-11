require "test_helper"

# Test controller to verify admin authentication
class TestAdminController < ApplicationController
  require_admin_authentication

  def test_action
    render plain: "Admin access granted"
  end
end

class AdminAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    # Add a test route for our test controller
    Rails.application.routes.draw do
      get "/test_admin", to: "test_admin#test_action"
      # Keep existing routes
      resource :session
      resources :passwords, param: :token
      get "up" => "rails/health#show", as: :rails_health_check
      root "sessions#new"
    end
  end

  teardown do
    # Restore original routes
    Rails.application.reload_routes!
  end

  test "admin user can access admin-only actions" do
    admin_user = users(:one)

    post session_path, params: {
      email_address: admin_user.email_address,
      password: "password",
    }

    get "/test_admin"

    assert_response :success
    assert_equal "Admin access granted", response.body
  end

  test "commenter user is denied access to admin-only actions" do
    commenter_user = users(:two)

    post session_path, params: {
      email_address: commenter_user.email_address,
      password: "password",
    }

    get "/test_admin"

    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "unauthenticated user is redirected to login for admin-only actions" do
    get "/test_admin"

    assert_redirected_to new_session_path
  end
end
