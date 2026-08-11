# frozen_string_literal: true

require "rails/generators"

module RailsApiKeysUi
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Copy rails_api_keys-ui controller into the host app"

      def copy_controller
        template "api_keys_controller.rb.tt", "app/controllers/api_keys_controller.rb"
      end
    end
  end
end
