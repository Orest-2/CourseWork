require 'securerandom'
class Api::V1::SuperAdminController < ApplicationController
  http_basic_authenticate_with name:
    'superadmin@mail.com', pass: '123123123', except: [:create_admin]

  def create_admin
    user = User.create(admin_params)

    render json: {
      email: user.email,
      password: user.password
    }
  end

  private

  def admin_params
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
