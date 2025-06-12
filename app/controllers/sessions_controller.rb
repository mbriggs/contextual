class SessionsController < ApplicationController
  include Logging

  allow_unauthenticated_access only: [:new, :create, :destroy]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    if Rails.env.development?
      load_dev_defaults
    end
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user
      logger.debug("Login successful for user: #{user.email_address}")
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Welcome back!"
    else
      logger.debug("Login failed for: #{params[:email_address]}")
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    logger.debug("Logout request received")

    # Resume session first to populate Current.session from cookie
    # (skipped by allow_unauthenticated_access but needed for logout)
    resume_session

    if Current.session
      terminate_session
    else
      logger.debug("No current session to terminate")
    end

    redirect_to new_session_path, notice: "You have been signed out."
  end

  # Pre-populate login form with credentials from .dev.json in development mode.
  # This provides a convenient way to quickly sign in during development without
  # having to remember or type credentials. The .dev.json file is gitignored
  # and created by bin/setup or bin/create-admin scripts.
  private def load_dev_defaults
    raise "load_dev_defaults should only be called in development" if !Rails.env.development?

    dev_config_file = Rails.root.join(".dev.json")
    return if !File.exist?(dev_config_file)

    begin
      config = JSON.parse(File.read(dev_config_file))
      @default_email = config.dig("user", "email")
      @default_password = config.dig("user", "password")
    rescue JSON::ParserError => e
      logger.warn("Failed to parse .dev.json: #{e.message}")
    end
  end
end
