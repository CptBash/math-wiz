class HealthCheckController < ApplicationController
  def index
    render json: { status: 'API is active' }, status: 200
  end
end
