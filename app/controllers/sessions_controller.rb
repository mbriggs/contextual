class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create, :destroy]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    load_dev_defaults if Rails.env.development?
  end

  def create
    if (user = User.authenticate_by(params.permit(:email_address, :password)))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Welcome back!"
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session if Current.session
    redirect_to new_session_path, notice: "You have been signed out."
  end

  private

  def load_dev_defaults
    dev_config_file = Rails.root.join(".dev.json")
    return unless File.exist?(dev_config_file)

    begin
      config = JSON.parse(File.read(dev_config_file))
      @default_email = config.dig("user", "email")
      @default_password = config.dig("user", "password")
    rescue JSON::ParserError
      # Silently ignore invalid JSON in development
    end
  end
end
