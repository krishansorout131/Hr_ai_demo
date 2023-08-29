class MainController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = extract_token_from_request(request)
    begin
      decoded_token = JWT.decode(
        token,
        Rails.application.credentials.devise_jwt_secret_key,
        true,
        algorithm: 'HS256'
      )
      
      user_id = decoded_token[0]['id']
      @current_user = User.find(user_id)
    rescue JWT::ExpiredSignature, JWT::VerificationError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def extract_token_from_request(request)
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
    token
  end

  def current_user
    @current_user
  end
end
