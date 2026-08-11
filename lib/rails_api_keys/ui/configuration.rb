# frozen_string_literal: true

module RailsApiKeys
  module UI
    # Host overrides. Set via {RailsApiKeys::UI.configure}.
    class Configuration
      attr_accessor :parent_controller,
                    :current_owner,
                    :authorize,
                    :policy_class,
                    :raw_token_flash_key,
                    :include_stylesheet

      def initialize
        @parent_controller = "ApplicationController"
        @current_owner = ->(controller) { controller.current_user }
        @authorize = nil
        @policy_class = "RailsApiKeys::UI::ApiKeyPolicy"
        @raw_token_flash_key = :rails_api_keys_raw_token
        @include_stylesheet = true
      end
    end
  end
end
