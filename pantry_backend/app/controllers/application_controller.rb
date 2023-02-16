# Super Controller for all other controllers
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_destroyed(err)
    render json: { errors: err.record.errors }, status: :unprocessable_entity
  end

  def not_found(err)
    render json: { errors: err.record.errors }, status: :unprocessable_entity
  end
end
