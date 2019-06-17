class Api::V1::CopyrightApplicationTasksController < ApplicationController
  before_action :auth_user_as_customer, only:
  %i[create update destroy]
  before_action :application_find, only:
  %i[create]
  before_action :application_task_find, only:
  %i[update destroy]

  def create
    application_task = @application.copyright_application_tasks.create(title: params[:title])

    if application_task.save
      render status: 201, json: {
        success: true,
        copyright_application_task: application_task
      }
    else
      @error = application_task.errors.full_messages
      render_error(400, nil, @error)
    end
  end

  def update
    application_task = @task.update(title: params[:title])
    if application_task
      application_task = application_task_find
      render status: 200, json: {
        success: true,
        copyright_application_task: application_task
      }
    else
      @error = application_task.errors.full_messages
      render_error(400, nil, @error)
    end
  end

  def destroy
    @task.destroy
    render status: 200, json: {
      success: true
    }
  end

  private

  def application_task_find
    @task = CopyrightApplicationTask.find(params[:id])
  rescue StandardError => e
    @error = e.message
    render_error(400, @prod, @error)
  end

  def application_find
    @application = CopyrightApplication.find(params[:copyright_application_id])
  rescue StandardError => e
    @error = e.message
    render_error(400, nil, @error)
    false
  end

  def application_params
    params.require(:copyright_application_task)
          .permit(:copyright_application_id, :title)
  end
end
