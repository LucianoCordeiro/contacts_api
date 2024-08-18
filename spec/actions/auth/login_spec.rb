require "rails_helper"

RSpec.describe Auth::Login do
  let!(:user) { FactoryBot.create(:user) }

  it 'login' do
    expect(user.auth_token).to be_blank

    token = "0a703baf27396ed4114d1aed869cf5492165fd0b"

    allow(User).to receive(:generate_token).and_return(token)

    subject = described_class.new(
      email: "luciano@luciano.com",
      password: "123456"
    )

    expect(subject.run).to eql token

    user.reload

    expect(user.password_digest).to be_present
    expect(user.auth_token).to eql(token)
  end

  it 'invalid password' do
    subject = described_class.new(
      email: "luciano@luciano.com",
      password: "654321"
    )

    expect { subject.run }.to raise_error(RuntimeError, "Senha inválida")

    expect(user.reload.auth_token).to be_blank
  end
end
