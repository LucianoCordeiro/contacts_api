class Auth::Login
  attr_reader :email, :password

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
  end

  def run
    user = User.find_by!(email: email)

    user.authenticate(password) ? user.refresh_auth_token : raise("Senha inválida")

    user.auth_token
  end
end
