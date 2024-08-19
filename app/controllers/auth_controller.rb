class AuthController < ActionController::API
  protected

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
