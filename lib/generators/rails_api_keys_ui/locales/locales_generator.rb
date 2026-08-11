# frozen_string_literal: true

require "rails/generators"

module RailsApiKeysUi
  module Generators
    class LocalesGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../../config/locales", __dir__)

      desc "Copy rails_api_keys-ui locale files into the host app"

      def copy_locales
        copy_file "en.yml", "config/locales/rails_api_keys_ui.en.yml"
      end
    end
  end
end
