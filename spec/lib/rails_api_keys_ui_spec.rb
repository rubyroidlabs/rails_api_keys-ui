# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsApiKeys::UI do
  it "has a version number" do
    expect(RailsApiKeys::UI::VERSION).to be_present
  end

  it "yields configuration" do
    described_class.configure do |config|
      config.raw_token_flash_key = :custom_token
    end

    expect(described_class.configuration.raw_token_flash_key).to eq(:custom_token)
  end
end
