class Auth::Signup
  attr_reader :email, :password

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
  end

  def run
    user = User.new(
      email: email,
      password: password,
      auth_token: User.generate_token
    )

    user.save! && user.auth_token
  end
end
