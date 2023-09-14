class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record_response

  def invalid_record_response(error)
    render json: ErrorSerializer.serialize_error(error, 422)
    response.status = 422
  end
end