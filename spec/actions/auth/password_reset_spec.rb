require "rails_helper"

RSpec.describe Auth::ResetPassword do
  let(:token) { "ad61de936d5264ea8bac773d5270f1e3a5f8ccff" }
  let(:user) { FactoryBot.create(:user, reset_password_token: token) }
  let!(:password_digest) { user.password_digest }

  it 'reset password' do
    expect(user.reset_password_token).to be_present

    described_class.new(
      reset_password_token: token,
      new_password: "654321"
    ).run

    user.reload

    expect(user.password_digest).to_not eql password_digest
    expect(user.reset_password_token).to be_blank
  end

  it 'wrong token' do
    subject = described_class.new(
      reset_password_token: "2074cf8b57eebfc25ef84bd62d4aad87f4395511",
      new_password: "654321"
    )

    expect { subject.run }.to raise_error(
      ActiveRecord::RecordNotFound,
      "Couldn't find User with [WHERE \"users\".\"reset_password_token\" = $1]"
    )

    user.reload

    expect(user.password_digest).to eql password_digest
    expect(user.reset_password_token).to be_present
  end
end
