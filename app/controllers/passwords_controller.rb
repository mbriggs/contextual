class PasswordsController < ApplicationController
  allow_unauthenticated_access

  def new
  end

  def edit
    @user = User.find_by_token_for!(:password_reset, params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def update
    @user = User.find_by_token_for!(:password_reset, params[:token])
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
  end
end
