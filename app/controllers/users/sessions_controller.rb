class Users::SessionsController < MainController
  # skip_before_action :verify_signed_out_user, only: [:destroy]
  before_action :restrict_access, except: [:create, :forget_password]

  # For Login a user
  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      render json: { message: 'Login successful', user: user, status: 200 }, status: 200
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # For Reset password when user is already login
  def reset_password
    if @current_user.valid_password?(params[:old_password])
      if params[:new_password] == params[:new_password_confirmation]
        @current_user.update(password: params[:new_password], password_confirmation: params[:new_password_confirmation])
        render json: { message: 'Password updated successfully' }
      else
        render json: { message: 'New password and password confirmation do not match' }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Old password is incorrect' }, status: :unprocessable_entity
    end
  end

  # For forget password
  def forget_password
    if params[:email].present?
      user = User.find_by(email: params[:email].downcase)
      
      if user
        user.send_reset_password_instructions
        render json: { message: "An email has been sent to #{params[:email]} for you to reset your password"}, status: 200
      else
        render json: { error: "No user found"}, status: 404
      end
    else
      render json: { error: "Incomplete parameters" }, status: 422
    end
  end

  # Edit user password
  def edit_password
    unless @current_user.blank?
      if params[:new_password] == params[:new_password_confirmation]
        @current_user.update(password: params[:new_password], password_confirmation: params[:new_password_confirmation])
        render json: { message: 'Password updated successfully' }, status: 200
      else
        render json: { message: 'New password and password confirmation do not match' }, status: 422
      end
    else
      render json: {error: 'No such user found!'}, status: 404
    end
  end
end
