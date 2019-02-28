# frozen_string_literal: true

# Module for render errors and success unified json
module UnifiedJsonRender
  extend ActiveSupport::Concern

  def render_error(error)
    msg = [error.split('[').first]
    msg ||= error

    render json: {
      success: false,
      msg: msg
    }
  end

  def render_class_error(class_def, error="Something went wrong")
    msg = class_def.errors.full_messages unless class_def.nil?
    msg ||= [error.split('[').first]

    render json: {
      success: false,
      msg: msg
    }
  end
end