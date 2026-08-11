# frozen_string_literal: true

require "rails/generators"

module RailsApiKeysUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install rails_api_keys-ui (initializer + optional Stimulus controllers)"

      def copy_initializer
        template "initializer.rb.tt", "config/initializers/rails_api_keys_ui.rb"
      end

      def copy_stimulus_controllers
        return unless yes?("Copy example Stimulus modal/clipboard controllers into the host app?")

        copy_file "javascript/modal_controller.js", "app/javascript/controllers/modal_controller.js"
        copy_file "javascript/clipboard_controller.js", "app/javascript/controllers/clipboard_controller.js"
      end

      def show_readme
        say <<~MSG

          rails_api_keys-ui installed.

          1. Draw routes, for example:

               resources :employees do
                 rails_api_keys_ui owner: :current_user, controller: "api_keys"
               end

               rails_api_keys_ui owner: :company, path: "company/api_keys"

          2. Views expect Stimulus controllers registered as `modal` and `clipboard`
             (open/close + openOnConnect; copy from source target). Skip the copy
             step above if your app already has compatible controllers.

          3. The panel inlines a scoped stylesheet by default. Override brand colors
             with --rak-ui-primary-600 / --rak-ui-primary-700 on .rails-api-keys-ui,
             or set config.include_stylesheet = false if you style it yourself.

          4. Optional: rails generate rails_api_keys_ui:controllers
                       rails generate rails_api_keys_ui:views
                       rails generate rails_api_keys_ui:locales

        MSG
      end
    end
  end
end
