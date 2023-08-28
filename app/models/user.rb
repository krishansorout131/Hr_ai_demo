class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable#, :confirmable
  
  before_create :ensure_token

  def ensure_token
    self.api_token = generate_access_token
  end

  private

  def generate_access_token
    loop do
      api_token = SecureRandom.uuid
      break api_token unless User.find_by(api_token: api_token)
    end
  end
end
