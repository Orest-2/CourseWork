class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ::UserAccessChecker
  include ::UnifiedJsonRender
end
