
require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:action) { double("action") }
  let(:auth_token) { "0f68d1b35901e96a19960f157906893bceac4401" }


  context 'signup' do
    let(:params) {
      {
        email: "luciano@luciano.com",
        password: "123456"
      }
    }

    before { allow(Auth::Signup).to receive(:new).with(params).and_return(action) }

    subject { post("/signup", params: params) }

    it 'success' do
      allow(action).to receive(:run).and_return auth_token

      subject

      expect(response.status).to eql 200
      expect(response.body).to eql({ token: auth_token }.to_json)
    end

    it 'failure' do
      allow(action).to receive(:run).and_raise("User already exists")

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "User already exists" }.to_json)
    end
  end

  context 'login' do
    let(:params) {
      {
        email: "luciano@luciano.com",
        password: "123456"
      }
    }

    before { allow(Auth::Login).to receive(:new).with(params).and_return(action) }

    subject { post("/login", params: params) }

    it 'success' do
      allow(action).to receive(:run).and_return auth_token

      subject

      expect(response.status).to eql 200
      expect(response.body).to eql({ token: auth_token }.to_json)
    end

    it 'failure' do
      allow(action).to receive(:run).and_raise("Invalid Password")

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Invalid Password" }.to_json)
    end
  end

  context 'send_reset_password_email' do
    let(:params) {
      {
        email: "luciano@luciano.com",
      }
    }

    before { allow(Auth::SendResetPasswordEmail).to receive(:new).with(params).and_return(action) }

    subject { post("/send_reset_password_email", params: params) }

    it 'success' do
      allow(action).to receive(:run).and_return auth_token

      subject

      expect(response.status).to eql 200
      expect(response.body).to eql({ message: "Email de recuperação de senha enviado" }.to_json)
    end

    it 'failure' do
      allow(action).to receive(:run).and_raise("Erro no envio do email")

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Erro no envio do email" }.to_json)
    end
  end

  context 'reset password' do
    let(:params) {
      {
        reset_password_token:"bab53b5311359000c881265442b50aedeb508b69",
        new_password: "654321"
      }
    }

    subject {
      put(
        "/reset_password/bab53b5311359000c881265442b50aedeb508b69",
        params: {
          new_password: "654321"
        }
      )
    }

    before { allow(Auth::ResetPassword).to receive(:new).with(params).and_return(action) }

    it 'success' do
      allow(action).to receive(:run)

      subject

      expect(response.status).to eql 200
      expect(response.body).to eql({ message: "Senha recuperada" }.to_json)
    end

    it 'failure' do
      allow(action).to receive(:run).and_raise("Token de reset inválido")

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Token de reset inválido" }.to_json)
    end
  end

  context 'logout' do
    subject { delete("/logout", headers: { Authorization: auth_token }) }

    it 'success' do
      FactoryBot.create(:user, auth_token: auth_token)

      subject

      expect(response.status).to eql 200
      expect(response.body).to eql({ message: "Usuário deslogado" }.to_json)
    end

    it 'failure' do
      FactoryBot.create(:user, auth_token: nil)

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Token inválido" }.to_json)
    end
  end

  context 'delete_account' do
    subject { delete("/delete_account", headers: { Authorization: auth_token }) }

    it 'success' do
      FactoryBot.create(:user, auth_token: auth_token)

      subject

      expect(response.status).to eql 200
      expect(response.body).to eql({ message: "Conta excluída" }.to_json)
    end

    it 'failure' do
      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Token inválido" }.to_json)
    end
  end
end
