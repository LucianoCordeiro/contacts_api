require "rails_helper"

RSpec.describe FindAddresses do
  it 'find addresses' do
    token = "0a703baf27396ed4114d1aed869cf5492165fd0b"

    FactoryBot.create(:user, auth_token: token)

    expected_payload = [
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

    allow(Faraday).to receive(:get).with(
      "http://viacep.com.br/ws/RS/Porto%20Alegre/Domingos/json"
    ).and_return(
      OpenStruct.new(body: expected_payload.to_json)
    )

    subject = described_class.new(
      state: "RS",
      city: "Porto Alegre",
      address_string: "Domingos"
    )

    expect(subject.run).to eql expected_payload
  end
end
