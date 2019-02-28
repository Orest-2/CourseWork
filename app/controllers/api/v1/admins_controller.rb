class Api::V1::AdminsController < ApplicationController
  include UserAccessChecker
  before_action :auth_user_as_admin

  def index
    render json: {
      secretaries: User.where(belong_to: current_user.id, is_secretary: true),
      executor: User.where(belong_to: current_user.id, is_executor: true)
    }
  end

  def create
    user = User.create(account_params)

    if user.errors.blank?
      render json: user
    else
      @error = user.errors.full_messages
      render_error(@error)
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy if user.belong_to == current_user.id

    render json: { msg: 'Success' }
  rescue ActiveRecord::RecordNotFound => exception
    @error = exception
    render_error(@error)
  end

  private

  def account_params
    {
      uid: params[:email],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      belong_to: current_user.id,
      is_secretary: params[:type] == 'secretary',
      is_executor: params[:type] == 'executor'
    }
  end
end
