class Api::V1::DirectorsController < ApplicationController
  include UserAccessChecker
  before_action :auth_user_as_admin

  def index
    render status: 200, json: {
      success: true,
      secretaries: User.where(belong_to: current_user.id, is_secretary: true),
      executor: User.where(belong_to: current_user.id, is_executor: true)
    }
  end

  def create
    @user = User.create(account_params)

    if @user.errors.blank?
      render status: 201, json: {
        success: true,
        user: @user
      }
    else
      render_error(400, @user)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy if @user.belong_to == current_user.id
    render status: 200, json: {
      success: true
    }
  rescue StandardError => e
    @error = e.message
    render_error(400, nil, @error)
  end

  def accept_copyright_applications
    application = CopyrightApplication.find(params[:id])
    director_id = current_user.id

    application.director_id = director_id
    application.acceptor_id = director_id
    application.status = 20

    if application.save
      render status: 200, json: {
        success: true,
        copyright_application: application
      }
    else
      @error = application.errors.full_messages
      render_error(400, nil, @error)
    end
  end

  def decline_copyright_applications
    application = CopyrightApplication.find(params[:id])

    application.director_id = nil
    application.acceptor_id = nil
    application.status = 10

    if application.save
      render status: 200, json: {
        success: true,
        copyright_application: application
      }
    else
      @error = application.errors.full_messages
      render_error(400, nil, @error)
    end
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
