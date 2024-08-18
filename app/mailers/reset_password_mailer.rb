class ResetPasswordMailer < ApplicationMailer
  default from: 'no-reply@example.com',
          return_path: 'system@example.com'

  def reset_instructions(email:, token:)
    @token = token

    mail(to: email, subject: "Recuperação de senha")
  end
end
