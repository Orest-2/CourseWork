require 'securerandom'

class Api::V1::SuperAdminController < ApplicationController
    http_basic_authenticate_with name: "superadmin@mail.com", pass: "123123123", except: [:create_admin]

    def create_admin
        password = SecureRandom.hex(8)
        admin_params = {
            uid:params[:email],
            email:params[:email],
            password: password, 
            password_confirmation: password,
            is_admin: true
        }
        
        User.create(admin_params)
        
        render json: {email:admin_params[:email], password:admin_params[:password]}
    end
end
