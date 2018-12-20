module UserAccessChecker
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only:
    [
      :auth_user_as_admin,
      :auth_user_as_executor,
      :auth_user_as_customer,
      :auth_user_as_secretary
    ]
  end

  %w[admin executor customer secretary].each do |role|
    define_method("auth_user_as_#{role}") do
      if current_user.nil?
        not_sing_in(role)
        return
      end
      return if role == 'admin' && current_user.is_admin?
      return if role == 'executor' && current_user.is_executor?
      return if role == 'secretary' && current_user.is_secretary?
      return if role == 'customer' && customer?

      not_access(role)
    end
  end

  def customer?
    !current_user.is_admin? &&
      !current_user.is_executor? &&
      !current_user.is_secretary?
  end

  def not_access(role)
    render json: {
      success: false,
      msg: "Login as #{role}"
    }
  end

  def not_sing_in(role)
    render json: {
      success: false,
      msg: "Please sing in as #{role}"
    }
  end
end
