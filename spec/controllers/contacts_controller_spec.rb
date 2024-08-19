
require 'rails_helper'

RSpec.describe 'Contact', type: :request do
  let(:action) { double("action") }
  let(:token) { "0f68d1b35901e96a19960f157906893bceac4401" }
  let!(:user) { FactoryBot.create(:user, auth_token: token) }

  context 'create contact' do
    let(:params) {
      {
        cpf: "04527671995",
        phone: "997975666",
        name: "Anderson dos Santos",
        address: "Av. Comendador Franco, 984",
      }
    }

    subject { post("/contacts", params: params, headers: { Authorization: token }) }

    before { allow(Geocoder).to receive(:search).and_return([OpenStruct.new(latitude: -25.4528583, longitude: -49.2434779)]) }

    it 'success' do
      subject

      contact = user.contacts.first

      contact_attributes = {
        id: contact.id,
        user_id: contact.user_id,
        name: "Anderson dos Santos",
        cpf: "04527671995",
        phone: "997975666",
        address: "Av. Comendador Franco, 984",
        latitude: -25.4528583,
        longitude: -49.2434779
      }

      expect(response.status).to eql 200
      expect(response.body).to eql({ contact: contact_attributes }.to_json)
    end

    it 'invalid cpf' do
      params[:cpf] = "0452767199"

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Validation failed: CPF deve ser válido" }.to_json)
    end
  end

  context 'update contact' do
    let(:contact) {
      FactoryBot.create(:contact, user: user, latitude: -25.4528583, longitude: -49.2434779)
    }

    let(:params) {
      {
        address: "Rua do Ouvidor"
      }
    }

    subject { put("/contacts/#{contact.id}", params: params, headers: { Authorization: token }) }

    before { allow(Geocoder).to receive(:search).and_return([OpenStruct.new(latitude: -22.9042883, longitude: -43.1793216)]) }

    it 'success' do
      subject

      contact = user.contacts.first

      contact_attributes = {
        user_id: contact.user_id,
        id: contact.id,
        address: "Rua do Ouvidor",
        cpf: "04527671995",
        latitude: -22.9042883,
        longitude: -43.1793216,
        name: "Anderson dos Santos",
        phone: "997975666"
      }

      expect(response.status).to eql 200
      expect(response.body).to eql({ contact: contact_attributes }.to_json)
    end

    it 'phone blank' do
      params[:phone] = ""

      subject

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Validation failed: Phone can't be blank" }.to_json)
    end
  end

  context 'destroy contact' do
    before { allow(Geocoder).to receive(:search).and_return([OpenStruct.new(latitude: -22.9042883, longitude: -43.1793216)]) }

    it 'success' do
      contact = FactoryBot.create(:contact, user: user)

      expect(user.contacts.count).to eql 1

      subject = delete("/contacts/#{contact.id}", headers: { Authorization: token })

      expect(response.status).to eql 200
      expect(response.body).to eql({ message: "Contato excluído" }.to_json)

      expect(user.contacts.count).to eql 0
    end

    it 'contact not found' do
      subject = delete("/contacts/9999", headers: { Authorization: token })

      expect(response.status).to eql 400
      expect(response.body).to eql({ error: "Couldn't find Contact with 'id'=9999 [WHERE \"contacts\".\"user_id\" = $1]" }.to_json)
    end
  end

  context 'list contacts' do
    before {
      allow(Geocoder).to receive(:search).and_return([OpenStruct.new(latitude: -22.9042883, longitude: -43.1793216)])

      @anderson = FactoryBot.create(:contact, user: user, cpf: CPF.generate)
      @jose = FactoryBot.create(:contact, user: user, cpf: CPF.generate, name: "José Dias")
    }

    it 'default query' do
      subject = get("/contacts", headers: { Authorization: token })

      contacts = [
        {
          id: @anderson.id,
          user_id: user.id,
          name: "Anderson dos Santos",
          cpf: @anderson.cpf,
          phone: "997975666",
          address: "Rua do Herval",
          latitude: -22.9042883,
          longitude: -43.1793216
        },
        {
          id: @jose.id,
          user_id: user.id,
          name: "José Dias",
          cpf: @jose.cpf,
          phone: "997975666",
          address: "Rua do Herval",
          latitude: -22.9042883,
          longitude: -43.1793216
        }
      ]

      expect(response.status).to eql 200
      expect(response.body).to eql({ contacts: contacts }.to_json)
    end

    it 'with pagination' do
      subject = get("/contacts", params: { page: 2, per_page: 1 }, headers: { Authorization: token })

      contacts = [
        {
          id: @jose.id,
          user_id: user.id,
          name: "José Dias",
          cpf: @jose.cpf,
          phone: "997975666",
          address: "Rua do Herval",
          latitude: -22.9042883,
          longitude: -43.1793216
        }
      ]


      expect(response.status).to eql 200
      expect(response.body).to eql({ contacts: contacts }.to_json)
    end

    it 'with cpf' do
      subject = get("/contacts", params: { cpf: @anderson.cpf }, headers: { Authorization: token })

      contacts = [
        {
          id: @anderson.id,
          user_id: user.id,
          name: "Anderson dos Santos",
          cpf: @anderson.cpf,
          phone: "997975666",
          address: "Rua do Herval",
          latitude: -22.9042883,
          longitude: -43.1793216
        }
      ]


      expect(response.status).to eql 200
      expect(response.body).to eql({ contacts: contacts }.to_json)
    end

    it 'with name' do
      subject = get("/contacts", params: { name: "Anderson" }, headers: { Authorization: token })

      contacts = [
        {
          id: @anderson.id,
          user_id: user.id,
          name: "Anderson dos Santos",
          cpf: @anderson.cpf,
          phone: "997975666",
          address: "Rua do Herval",
          latitude: -22.9042883,
          longitude: -43.1793216
        }
      ]

      expect(response.status).to eql 200
      expect(response.body).to eql({ contacts: contacts }.to_json)
    end

    it 'descending order' do
      subject = get("/contacts", params: { order_type: "desc" }, headers: { Authorization: token })

      contacts = [
        {
          id: @jose.id,
          user_id: user.id,
          name: "José Dias",
          cpf: @jose.cpf,
          phone: "997975666",
          address: "Rua do Herval",
          latitude: -22.9042883,
          longitude: -43.1793216
        },
        {
          id: @anderson.id,
          user_id: user.id,
          name: "Anderson dos Santos",
          cpf: @anderson.cpf,
          phone: "997975666",
          address: "Rua do Herval",
          latitude: -22.9042883,
          longitude: -43.1793216
        }
      ]

      expect(response.status).to eql 200
      expect(response.body).to eql({ contacts: contacts }.to_json)
    end
  end
end
