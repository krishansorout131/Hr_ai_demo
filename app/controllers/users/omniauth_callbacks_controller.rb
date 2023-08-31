# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :json
  
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    user = User.from_omniauth(request.env['omniauth.auth'], 'google_oauth2')
    if user.persisted?
      render json: { message: "user created successfulluy", token: user.get_access_token, status: 200 }, status: 200
    else
      render json: { error: "Please try again", status: 400 }, status: 200
    end
  end
end
