class Api::V1::UserParamsController < ApplicationController
  before_action :authenticate_user!

  def show
    if !current_user.user_param.nil?
      render status: 200, json: {
        success: true,
        user_param: current_user.user_param
      }
    else
      render_error(400, nil, "user params doesn't exist")
    end
  end

  def create
    if current_user.user_param.nil?
      user_param = current_user.build_user_param(user_params)

      if user_param.save
        render status: 201, json: {
          success: true,
          user_param: user_param
        }
      else
        @error = application.errors.full_messages
        render_error(400, nil, @error)
      end
    else
      render_error(400, nil, 'user params already exist')
    end
  end

  def update
    if !current_user.user_param.nil?
      user_param = current_user.user_param.update_attributes(user_params)

      if user_param
        render status: 200, json: {
          success: true,
          user_param: current_user.user_param
        }
      else
        @error = application.errors.full_messages
        render_error(400, nil, @error)
      end
    else
      render_error(400, nil, "user params doesn't exist")
    end
  end

  private

  def user_params
    {
      email: params[:email],
      first_name: params[:first_name],
      last_name: params[:last_name],
      address: params[:address]
    }
  end
end
