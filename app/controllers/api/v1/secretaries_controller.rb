class Api::V1::SecretariesController < ApplicationController
  before_action :auth_user_as_secretary, only:
                %i[accept_copyright_applications]

  def accept_copyright_applications
    application = CopyrightApplication.find(params[:id])
    secretary_id = current_user.id
    director_id = current_user.belong_to

    application.director_id = director_id
    application.acceptor_id = secretary_id
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
end
