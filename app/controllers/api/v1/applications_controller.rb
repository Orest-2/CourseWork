class Api::V1::ApplicationsController < ApplicationController
  before_action :auth_user_as_customer, only:
                %i[index create update show destory]
  before_action :authenticate_user!, only:
                %i[index]

  api :GET, '/v1/applications'
  def index
    applications = []
    if current_user.is_admin
      applications = CopyrightApplication.all
    else
      applications = CopyrightApplication.where(customer_id: current_user.id)
    end
    render json: {
      applications: applications
    }
  end

  def create
    return unless product_exist?

    params[:application][:customer_id] = current_user.id
    application = CopyrightApplication.create(application_params)

    if application.save
      index
    else
      @errors = application.errors.full_messages
      render_error
    end
  end

  def update
    application = application_find

    return unless application

    params[:application].delete :product_id
    params[:application].delete :customer_id

    if application.update(application_params)
      index
    else
      @errors = application.errors.full_messages
      render_error
    end
  end

  def show
    render json: application_find if application_find
  end

  def destroy; end

  private

  def application_find
    CopyrightApplication.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    @errors = e.message
    render_error
    false
  end

  def product_exist?
    current_user.products.find(params[:product_id])
    true
  rescue ActiveRecord::RecordNotFound => e
    @errors = e.message
    render_error
    false
  end

  def render_error
    msg = [@errors.split('[').first]
    msg ||= @errors

    render json: {
      success: false,
      msg: msg
    }
  end

  def application_params
    params.require(:application)
          .permit(:customer_id, :title, :keywords, :product_id)
  end
end
