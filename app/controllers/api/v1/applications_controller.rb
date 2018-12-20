class Api::V1::ApplicationsController < ApplicationController
  before_action :auth_user_as_customer, only:
                %i[index create update show destory]

  def index
    render json: {
      applications: Application.where(customer_id: current_user.id)
    }
  end

  def create
    return unless product_exist?

    params[:application][:customer_id] = current_user.id
    application = Application.create(application_params)

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
    Application.find(params[:id])
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
          .permit(:title, :keyword, :product_id)
  end
end
