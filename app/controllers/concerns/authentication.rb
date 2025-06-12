module Authentication
  extend ActiveSupport::Concern
  include Logging

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user, :admin_signed_in?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end

    def require_admin_authentication(**options)
      before_action :authenticate_admin!, **options
    end
  end

  private def authenticated?
    result = resume_session
    logger.debug("Authentication check: #{result ? 'authenticated' : 'not authenticated'}")
    result
  end

  private def current_user
    Current.session&.user
  end

  private def admin_signed_in?
    auth_result = authenticated?
    admin_result = current_user&.admin?
    result = auth_result && admin_result
    logger.debug("Admin signed in check: authenticated=#{auth_result}, admin=#{admin_result}, result=#{result}")
    result
  end

  private def authenticate_admin!
    logger.debug("Authenticating admin access")
    require_authentication

    if !current_user&.admin?
      logger.debug("Admin access denied - user is not admin")
      redirect_to root_path, alert: "Access denied. Admin privileges required."
    else
      logger.debug("Admin access granted")
    end
  end

  private def require_authentication
    result = resume_session || request_authentication
    logger.debug("Authentication required - session resumed: #{!resume_session.nil?}")
    result
  end

  private def resume_session
    session_id = cookies.signed[:session_id]
    logger.debug("Resuming session with cookie session_id: #{session_id ? 'present' : 'nil'}")

    Current.session ||= find_session_by_cookie

    if Current.session
      logger.debug("Session resumed successfully - user: #{Current.session.user&.email_address}")
    else
      logger.debug("No valid session found")
    end

    Current.session
  end

  private def find_session_by_cookie
    session_id = cookies.signed[:session_id]
    return nil unless session_id

    session = Session.find_by(id: session_id)
    logger.debug("Looking up session #{session_id}: #{session ? 'found' : 'not found'}")
    session
  end

  private def request_authentication
    logger.debug("Requesting authentication - redirecting to login")
    session[:return_to_after_authenticating] = request.url
    redirect_to new_session_path
  end

  private def after_authentication_url
    session.delete(:return_to_after_authenticating) || root_url
  end

  private def start_new_session_for(user)
    logger.debug("Starting new session for user: #{user.email_address}")
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      logger.debug("Session created with ID: #{session.id}")
    end
  end

  private def terminate_session
    session_id = Current.session&.id
    logger.debug("Terminating session #{session_id}")

    Current.session&.destroy
    Current.session = nil
    cookies.delete(:session_id)

    logger.debug("Session terminated and cookie cleared")
  end
end
