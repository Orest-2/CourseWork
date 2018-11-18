class Api::V1::AdminsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json:{
      secretaries: User.where(belong_to: current_user.id, is_secretary: true),
      executor: User.where(belong_to: current_user.id, is_executor: true)
    }
  end

  def create
    executor_params = {
      uid:params[:email],
      email:params[:email],
          password:params[:password], 
      password_confirmation:params[:password_confirmation],
      is_executor: true
    }

    secretary_params = {
      uid:params[:email],
      email:params[:email],
      password:params[:password], 
      password_confirmation:params[:password_confirmation],
      is_secretary: true
    }

    if params[:type] == "secretary"
      user = User.create(secretary_params)
    elsif params[:type] == "executor"            
      user = User.create(executor_params)
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
