module UserAccessChecker
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only:
    %i[
      auth_user_as_admin
      auth_user_as_executor
      auth_user_as_customer
      auth_user_as_secretary
      auth_user_as_admin_or_customer
    ]
  end

  %w[admin executor customer secretary admin_or_customer admin_or_secretary].each do |role|
    define_method("auth_user_as_#{role}") do
      if current_user.nil?
        not_sing_in(role)
        return
      end
      return if role == 'admin' && current_user.is_admin?
      return if role == 'executor' && current_user.is_executor?
      return if role == 'secretary' && current_user.is_secretary?
      return if role == 'customer' && customer?
      return if role == 'admin_or_customer' && customer? || current_user.is_admin? || current_user.is_secretary? || current_user.is_executor?
      return if role == 'admin_or_secretary' && current_user.is_secretary? || current_user.is_admin?

      not_access(role)
    end
  end 

  def customer?
    !current_user.is_admin? &&
      !current_user.is_executor? &&
      !current_user.is_secretary?
  end

  def not_access(role)
    render status: 403, json: {
      success: false,
      msg: ["Login as #{role}"]
    }
  end

  def not_sing_in(role)
    render status: 401, json: {
      success: false,
      msg: ["Please sing in as #{role}"]
    }
  end
end