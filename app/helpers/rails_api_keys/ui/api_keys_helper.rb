# frozen_string_literal: true

module RailsApiKeys
  module UI
    module ApiKeysHelper
      # Renders the embeddable API keys panel (list + create/reveal modals).
      #
      # Reads the reveal-once raw token from flash when +raw_token+ is omitted.
      #
      # @param api_keys [Enumerable]
      # @param create_path [String]
      # @param destroy_path [Proc, #call] receives an api_key, returns path
      # @param raw_token [String, nil]
      def rails_api_keys_ui_panel(api_keys:, create_path:, destroy_path:, raw_token: nil)
        render partial: "rails_api_keys/ui/api_keys/panel",
               locals: {
                 api_keys: api_keys,
                 create_path: create_path,
                 destroy_path: destroy_path,
                 raw_token: raw_token.nil? ? flash[RailsApiKeys::UI.configuration.raw_token_flash_key] : raw_token
               }
      end

      # Inlines the gem stylesheet once per render (no asset pipeline required).
      # Disable with +config.include_stylesheet = false+ when the host supplies styles.
      def rails_api_keys_ui_stylesheet
        return "".html_safe unless RailsApiKeys::UI.configuration.include_stylesheet
        return "".html_safe if @_rails_api_keys_ui_stylesheet_rendered

        @_rails_api_keys_ui_stylesheet_rendered = true
        content_tag(:style, ApiKeysHelper.stylesheet_contents, type: "text/css")
      end

      def self.stylesheet_path
        Engine.root.join("app/assets/stylesheets/rails_api_keys/ui.css")
      end

      def self.stylesheet_contents
        @stylesheet_contents ||= File.read(stylesheet_path).html_safe
      end
    end
  end
end
