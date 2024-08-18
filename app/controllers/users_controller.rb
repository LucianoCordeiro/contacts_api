class UsersController < ActionController::API
  before_action :logged_in?, only: [:logout, :delete_account]

  def signup
    token = Auth::Signup.new(
      email: params[:email],
      password: params[:password]
    ).run

    render json: {
      token: token
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def login
    token = Auth::Login.new(
      email: params[:email],
      password: params[:password]
    ).run

    render json: {
      token: token
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def send_reset_password_email
    Auth::SendResetPasswordEmail.new(
      email: params[:email]
    ).run

    render json: {
      message: "Email de recuperação de senha enviado"
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def reset_password
    Auth::ResetPassword.new(
      reset_password_token: params[:reset_password_token],
      new_password: params[:new_password]
    ).run

    render json: {
      message: "Senha recuperada"
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def logout
    current_user.update(auth_token: nil)

    render json: {message: "Usuário deslogado"}
  end

  def delete_account
    current_user.delete

    render json: {message: "Conta excluída"}
  end

  private

  def header_token
    request.headers['Authorization']
  end

  def current_user
    @current_user ||= User.find_by(auth_token: header_token)
  end

  def logged_in?
    render json: {error: "Token inválido"}, status: 400 unless current_user
  end
end
