# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsApiKeys::UI::ApiKeysHelper, type: :helper do
  describe "#rails_api_keys_ui_stylesheet" do
    it "inlines the scoped stylesheet once" do
      first = helper.rails_api_keys_ui_stylesheet
      second = helper.rails_api_keys_ui_stylesheet

      expect(first).to include("--rak-ui-primary-600")
      expect(first).to include(".rails-api-keys-ui")
      expect(second).to eq("")
    end

    it "can be disabled via configuration" do
      RailsApiKeys::UI.configure { |c| c.include_stylesheet = false }

      expect(helper.rails_api_keys_ui_stylesheet).to eq("")
    ensure
      RailsApiKeys::UI.reset_configuration!
    end
  end
end
