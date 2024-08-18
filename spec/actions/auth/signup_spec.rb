require "rails_helper"

RSpec.describe Auth::Signup do

  it 'create user' do
    token = "0a703baf27396ed4114d1aed869cf5492165fd0b"

    allow(User).to receive(:generate_token).and_return(token)

    subject = described_class.new(
      email: "luciano@luciano.com",
      password: "123456"
    )

    expect(subject.run).to eql token

    user = User.find_by(email: "luciano@luciano.com")

    expect(user).to be_present
    expect(user.password_digest).to be_present
    expect(user.auth_token).to eql(token)
  end

  it 'user already exists' do
    FactoryBot.create(:user)

    subject = described_class.new(
      email: "luciano@luciano.com",
      password: "123456"
    )

    expect { subject.run }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email has already been taken")
  end

  it 'password is too short' do
    subject = described_class.new(
      email: "luciano@luciano.com",
      password: "12345"
    )

    expect { subject.run }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password is too short (minimum is 6 characters)")
  end
end
