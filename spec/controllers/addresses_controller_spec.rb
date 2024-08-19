
require 'rails_helper'

RSpec.describe 'Address', type: :request do
  let(:action) { double("action") }
  let(:token) { "0f68d1b35901e96a19960f157906893bceac4401" }
  let!(:user) { FactoryBot.create(:user, auth_token: token) }

  context 'find addresses' do
    let(:params) {
      {
        state: "AM",
        city: "Parintins",
        address_string: "Oswaldo"
      }
    }

    before { allow(FindAddresses).to receive(:new).with(params).and_return(action) }

    subject { get("/find_addresses", params: params, headers: { Authorization: token }) }

    it 'success' do
      addresses = [
        {
          "cep"=>"91420-270",
          "logradouro"=>"Rua São Domingos",
          "complemento"=>"",
          "unidade"=>"",
          "bairro"=>"Bom Jesus",
          "localidade"=>"Porto Alegre",
          "uf"=>"RS",
          "ibge"=>"4314902",
          "gia"=>"",
          "ddd"=>"51",
          "siafi"=>"8801"
        }
      ]

      allow(action).to receive(:run).and_return addresses

      subject

      expect(response.status).to eql 200
      expect(response.body).to eql({ addresses: addresses }.to_json)
    end

    it 'failure' do
      allow(action).to receive(:run).and_raise("Service temporarily unavailable")

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Service temporarily unavailable" }.to_json)
    end
  end
end
