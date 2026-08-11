# frozen_string_literal: true

require "rails/generators"

module RailsApiKeysUi
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../../app/views/rails_api_keys/ui", __dir__)

      desc "Copy rails_api_keys-ui views into the host app for editing"

      def copy_views
        directory "api_keys", "app/views/rails_api_keys/ui/api_keys"
      end
    end
  end
end
