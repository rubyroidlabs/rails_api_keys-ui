# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RailsApiKeys::UI api keys", type: :request do
  let(:user) { User.create!(email: "owner@example.com") }
  let(:other) { User.create!(email: "other@example.com") }

  def sign_in(u)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(u)
  end

  describe "nested under users with owner: :current_user" do
    before { sign_in(user) }

    it "creates a key for current_user and returns raw token in flash" do
      expect {
        post user_api_keys_path(user), params: { api_key: { name: "Zapier", permission: "read" } }
      }.to change { user.api_keys.count }.by(1)

      expect(response).to redirect_to(user_api_keys_path(user))
      expect(flash[:rails_api_keys_raw_token]).to be_present
    end

    it "lists active keys as JSON" do
      user.create_api_key!(name: "A", permission: :read)
      get user_api_keys_path(user, format: :json)

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
      expect(body.first["name"]).to eq("A")
      expect(body.first).not_to have_key("raw_token")
    end

    it "returns raw_token once on JSON create" do
      post user_api_keys_path(user, format: :json),
           params: { api_key: { name: "CLI", permission: "read_write" } }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["raw_token"]).to be_present
      expect(body["name"]).to eq("CLI")
    end

    it "revokes a key" do
      key, = user.create_api_key!(name: "Temp", permission: :read)

      delete user_api_key_path(user, key)

      expect(response).to redirect_to(user_api_keys_path(user))
      expect(key.reload).to be_revoked
    end
  end

  describe "nested under companies with owner: :company" do
    let(:company) { Company.create!(name: "Acme") }

    before do
      sign_in(user)
      RailsApiKeys::UI.configure do |config|
        config.authorize = ->(_controller, _action, _record) { true }
      end
    end

    it "creates a key owned by the company" do
      expect {
        post company_api_keys_path(company), params: { api_key: { name: "Billing", permission: "read" } }
      }.to change { company.api_keys.count }.by(1)

      expect(company.api_keys.last.owner).to eq(company)
    end
  end

  describe "flat account mount" do
    before { sign_in(user) }

    it "creates via /account/api_keys" do
      expect {
        post account_api_keys_path, params: { api_key: { name: "Flat", permission: "read" } }
      }.to change { user.api_keys.count }.by(1)
    end
  end
end
