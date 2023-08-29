class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
  
  def get_access_token
    generate_jwt
  end

  private

  def generate_jwt
    JWT.encode(
      { id: id, jti: jti, exp: 30.days.from_now.to_i },
      Rails.application.credentials.devise_jwt_secret_key
    )
  end
end
