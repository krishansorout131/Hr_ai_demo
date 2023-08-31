class Users::SessionsController < MainController
  before_action :authenticate_user!, except: [:create, :edit_password, :forgot_password]

  # For Login a user
  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      render json: { message: 'Login successful',
        user: UserSerializer.new(user).serializable_hash[:data][:attributes],
        token: user.get_access_token,
        status: 200 
      }, status: 200
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
    user = User.reset_password_by_token(reset_password_token: params[:reset_password_token])
    if user && user.persisted?
      if params[:new_password] == params[:new_password_confirmation]
        user.update(password: params[:new_password], password_confirmation: params[:new_password_confirmation])
        render json: { message: 'Password updated successfully' }, status: 200
      else
        render json: { message: 'New password and password confirmation do not match' }, status: 422
      end
    else
      render json: {error: 'The token has expired, please generate new token through the forget password link.'}, status: 404
    end
  end

  def get_user
    render json: { user: UserSerializer.new(@current_user).serializable_hash[:data][:attributes] }
  end
end
