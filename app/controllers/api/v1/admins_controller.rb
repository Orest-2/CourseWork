class Api::V1::AdminsController < ApplicationController
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
      render json: user.errors.full_messages
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy if user.belong_to == current_user.id

    render json: { msg: 'Secsses' }
  rescue ActiveRecord::RecordNotFound => exception
    render json: { msg: exception }
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
