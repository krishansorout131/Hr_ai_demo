class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, :jwt_authenticatable, jwt_revocation_strategy: self, omniauth_providers: [:google_oauth2]
  
  def get_access_token
    generate_jwt
  end

  def self.from_omniauth(response ,provider)
    if provider == 'google_oauth2'
      first_name = response.info.first_name
      last_name = response.info.last_name
      email = response.info.email
    end
    user = User.find_or_create_by(email: email ) do |user|
      user.password = "123456"
      user.first_name = first_name
      user.last_name = last_name
    end
    user
  end

  private

  def generate_jwt
    JWT.encode(
      { id: id, jti: jti, exp: 30.days.from_now.to_i },
      Rails.application.credentials.devise_jwt_secret_key
    )
  end
end
