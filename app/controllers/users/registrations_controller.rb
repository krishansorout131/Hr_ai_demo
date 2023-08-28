class Users::RegistrationsController < MainController
  before_action :restrict_access, except: [:create]

  def create
    user = User.new(sign_up_params)
  
    if user.password == user.password_confirmation && user.save
      render json: { message: 'Signup successful', user: user }
    else
      error_message = user.errors.full_messages.join(', ')
      error_message += ', Password and password confirmation do not match' if user.password != user.password_confirmation
      render json: { message: error_message }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end