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

    it "creates a key for current_user with optional allowed_ips and returns raw token in flash" do
      expect {
        post user_api_keys_path(user),
             params: { api_key: { name: "Zapier", permission: "read", allowed_ips: "203.0.113.10\n10.0.0.0/24" } }
      }.to change { user.api_keys.count }.by(1)

      expect(response).to redirect_to(user_api_keys_path(user))
      expect(flash[:rails_api_keys_raw_token]).to be_present
      expect(user.api_keys.last.allowed_ips).to eq([ "203.0.113.10", "10.0.0.0/24" ])
    end

    it "lists active keys as JSON including allowed_ips" do
      user.create_api_key!(name: "A", permission: :read, allowed_ips: [ "203.0.113.10" ])
      get user_api_keys_path(user, format: :json)

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
      expect(body.first["name"]).to eq("A")
      expect(body.first["allowed_ips"]).to eq([ "203.0.113.10" ])
      expect(body.first).not_to have_key("raw_token")
    end

    it "returns raw_token once on JSON create with allowed_ips array" do
      post user_api_keys_path(user, format: :json),
           params: { api_key: { name: "CLI", permission: "read_write", allowed_ips: [ "10.0.0.0/24" ] } }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["raw_token"]).to be_present
      expect(body["name"]).to eq("CLI")
      expect(body["allowed_ips"]).to eq([ "10.0.0.0/24" ])
    end

    it "updates allowed_ips via HTML PATCH" do
      key, = user.create_api_key!(name: "Scoped", permission: :read)

      patch user_api_key_path(user, key),
            params: { api_key: { allowed_ips: "203.0.113.10, 10.0.0.0/24" } }

      expect(response).to redirect_to(user_api_keys_path(user))
      expect(key.reload.allowed_ips).to eq([ "203.0.113.10", "10.0.0.0/24" ])
    end

    it "updates allowed_ips via JSON PATCH and rejects invalid IPs" do
      key, = user.create_api_key!(name: "Scoped", permission: :read)

      patch user_api_key_path(user, key, format: :json),
            params: { api_key: { allowed_ips: [ "203.0.113.10" ] } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["allowed_ips"]).to eq([ "203.0.113.10" ])

      patch user_api_key_path(user, key, format: :json),
            params: { api_key: { allowed_ips: [ "not-an-ip" ] } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end

    it "renders HTML index with allowed IPs and edit modal" do
      user.create_api_key!(name: "Prod", permission: :read, allowed_ips: [ "203.0.113.10" ])

      get user_api_keys_path(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("203.0.113.10")
      expect(response.body).to include("Edit IPs")
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
