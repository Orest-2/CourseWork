require 'securerandom'
class Api::V1::AdminsController < ApplicationController
  http_basic_authenticate_with name:
    'admin123', password: 'admin123', except: [:create]

  def create
    @user = User.create(directors_params)

    if @user.save
      render status: 201, json: {
        success: true,
        email: @user.email,
        password: @user.password
      }
    else
      render_error(400, @user)
    end
  end

  private

  def directors_params
    password = SecureRandom.hex(8)

    {
      uid: params[:email],
      email: params[:email],
      password: password,
      password_confirmation: password,
      is_admin: true
    }
  end
end
