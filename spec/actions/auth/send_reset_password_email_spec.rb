require "rails_helper"

RSpec.describe Auth::SendResetPasswordEmail do
  let!(:user) { FactoryBot.create(:user) }
  let(:mailer) { double("mailer") }

  subject {
    described_class.new(
      email: "luciano@luciano.com",
    )
  }

  before { allow(ResetPasswordMailer).to receive(:reset_instructions).and_return(mailer) }

  it 'send reset password instructions' do
    expect(user.reset_password_token).to be_blank

    allow(mailer).to receive(:deliver_now)

    token = "0a703baf27396ed4114d1aed869cf5492165fd0b"

    allow(User).to receive(:generate_token).and_return(token)

    subject.run

    expect(user.reload.reset_password_token).to eql token

    expect(ResetPasswordMailer).to have_received(:reset_instructions)
    expect(mailer).to have_received(:deliver_now)
  end

  it 'something goes wrong with email sending' do
    allow(mailer).to receive(:deliver_now).and_raise("Something goes wrong")

    expect { subject.run }.to raise_error("Something goes wrong")
  end
end
