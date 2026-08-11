# frozen_string_literal: true

require "rails_api_keys"
require "rails_api_keys/ui/version"
require "rails_api_keys/ui/configuration"
require "rails_api_keys/ui/mount_registry"

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "UI"
end

require "rails_api_keys/ui/engine"

module RailsApiKeys
  # HTML/JSON management UI for {RailsApiKeys::ApiKey}.
  module UI
    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield configuration
      end

      def reset_configuration!
        @configuration = Configuration.new
      end

      def mounts
        @mounts ||= MountRegistry.new
      end

      def reset_mounts!
        mounts.clear!
      end
    end
  end
end
