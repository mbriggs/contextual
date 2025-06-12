class ApplicationController < ActionController::Base
  include Logging
  include Authentication
  allow_browser versions: :modern
end
