class Auth::ResetPassword
  attr_reader :reset_password_token, :new_password

  def initialize(params)
    @reset_password_token = params[:reset_password_token]
    @new_password = params[:new_password]
  end

  def run
    user = User.find_by!(
      reset_password_token: reset_password_token
    )

    user.update!(
      password: new_password,
      reset_password_token: nil
    )
  end
end
