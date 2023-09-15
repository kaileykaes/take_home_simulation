class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record_response
  rescue_from ActiveRecord::RecordNotFound, with: :no_record_response
  rescue_from ActionController::RoutingError, with: :no_record_response

  def invalid_record_response(error)
    base_response(error, 422)
    response.status = 422
  end

  def no_record_response(error)
    base_response(error, 404)
    response.status = 404
  end

  private
  def base_response(error, status)
    render json: ErrorSerializer.serialize_error(error, status)
  end
end