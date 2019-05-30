class Api::V1::CopyrightApplicationsController < ApplicationController
  before_action :auth_user_as_customer, only:
  %i[create update show destroy]
  before_action :auth_user_as_admin_or_customer, only:
  %i[index submit unsubmit]
  before_action :application_find, only:
  %i[destroy submit unsubmit sharing done]
  before_action :auth_user_as_admin_or_secretary, only:
  %i[accept_copyright_applications decline_copyright_applications sharing done]

  def index
    applications = if current_user.is_admin || current_user.is_secretary
                     CopyrightApplication.where("status >= '10'").to_a
                   elsif current_user.is_executor
                     id = current_user.id
                     CopyrightApplication.where(executor_id: id).to_a
                   else
                     id = current_user.id
                     CopyrightApplication.where(customer_id: id).to_a
                   end

    render status: 200, json: {
      success: true,
      copyright_applications: get_applications_with_tasks(applications)
    }
  end

  def create
    return unless product_exist?

    params[:copyright_application][:customer_id] = current_user.id
    application = CopyrightApplication.create(application_params)

    if application.save
      save_applications_tasks(application)
      render status: 201, json: {
        success: true,
        copyright_application: get_applications_with_tasks(application)
      }
    else
      @error = application.errors.full_messages
      render_error(400, nil, @error)
    end
  end

  def update
    application = application_find

    return unless application

    #params[:copyright_application].delete :product_id
    params[:copyright_application].delete :customer_id
    if application.update(application_params)
      application = application_find
      render status: 200, json: {
        success: true,
        copyright_application: get_applications_with_tasks(application)
      }
    else
      @error = application.errors.full_messages
      render_error(@error)
    end
  end

  def show
    application = application_find
    return unless application

    render status: 200, json: {
      success: true,
      copyright_application: get_applications_with_tasks(application)
    }
  end

  def destroy
    @application.copyright_application_tasks.each &:destroy
    @application.destroy
    render status: 200, json: {
      success: true
    }
  end

  def submit
    change_status(10)
    render status: 200, json: {
      success: true,
      copyright_application: @application
    }
  end

  def unsubmit
    change_status(0)
    @application.executor_id = nil
    @application.save
    render status: 200, json: {
      success: true,
      copyright_application: @application
    }
  end

  def sharing
    change_status(30)
    @application.executor_id = params[:executor_id]
    @application.save
    render status: 200, json: {
      success: true,
      copyright_application: @application
    }
  end

  def done
    change_status(40)
    render status: 200, json: {
      success: true,
      copyright_application: @application
    }
  end

  def accept_copyright_applications
    application = CopyrightApplication.find(params[:id])

    if(current_user.is_admin != 1)
      application.director_id = current_user.belong_to
    else
      application.director_id = current_user.id
    end
    application.acceptor_id = current_user.id
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

    if(current_user.is_admin != 1)
      application.director_id = current_user.belong_to
    else
      application.director_id = current_user.id
    end
    application.acceptor_id = current_user.id
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

  def application_find
    @application = CopyrightApplication.find(params[:id])
  rescue StandardError => e
    @error = e.message
    render_error(400, nil, @error)
    false
  end

  def change_status(status)
    @application.status = status
    @application.save
  end

  def get_applications_with_tasks(application)
    res = application.is_a?(Array) ? application : [application]
    application_arr = []
    res.each do |value|
      application_attributes = value.attributes
      application_attributes['tasks'] = value.copyright_application_tasks
      application_arr << application_attributes
    end
    application.is_a?(Array) ? application_arr : application_arr.first
  end

  def save_applications_tasks(application)
    params[:tasks].each do |task|
      application.copyright_application_tasks.create(title: task[:title])
    end
  end

  def product_exist?
    current_user.products.find(params[:product_id])
    true
  rescue StandardError => e
    @error = e.message

    render status: 401, json: {
      success: false,
      msg: @error
    }
    
    false
  end

  def application_params
    params.require(:copyright_application)
          .permit(:customer_id, :title, :description, :product_id)
  end
end
