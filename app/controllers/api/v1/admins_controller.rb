class Api::V1::AdminsController < ApplicationController
  before_action :auth_user_as_admin

  def index
    render json:{
      secretaries: User.where(belong_to: current_user.id, is_secretary: true),
      executor: User.where(belong_to: current_user.id, is_executor: true)
    }
  end

  def create
    account_params = {
      uid:params[:email],
      email:params[:email],
      password:params[:password],
      password_confirmation:params[:password_confirmation],
    }

    if params[:type] == "secretary"
      user = User.create(account_params.merge(is_secretary: true))
    elsif params[:type] == "executor"
      user = User.create(account_params.merge(is_executor: true))
    end

    if user.errors.blank?
      render json: user
    else
      render json: user.errors.full_messages
    end
  end

  def destroy
    begin
      User.find(params[:id]).destroy
      render json: {msg:"Secsses"}
    rescue => exception
      pp exception
      render json: {msg:exception}
    end
  end
end
