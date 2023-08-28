class MainController < ApplicationController
  before_action :restrict_access

  private
  
  def restrict_access
    access_token = request.headers["Authorization"]
    unless access_token.blank?
      user = User.find_by(api_token: access_token)
      if user.present?
        @current_user = user
      else
        render json: { error: "Access Token not found", status: 400 }, status: 200
      end
    else
      render json: { error: "Access Token not provided", status: 400 }, status: 200
    end
  end
end