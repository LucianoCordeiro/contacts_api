class Auth::SendResetPasswordEmail
  attr_reader :email

  def initialize(params)
    @email = params[:email]
  end

  def run
    user = User.find_by!(email: email)

    user.refresh_reset_password_token

    ResetPasswordMailer.reset_instructions(
      email: user.email,
      token: user.reset_password_token
    ).deliver_now
  end
end
