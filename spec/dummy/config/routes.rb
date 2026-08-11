# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    rails_api_keys_ui owner: :current_user, name: "user_api_keys"
  end

  resources :companies do
    rails_api_keys_ui owner: :company, name: "company_api_keys"
  end

  rails_api_keys_ui owner: :current_user,
                    path: "account/api_keys",
                    name: "account_api_keys",
                    as: :account_api_keys
end
