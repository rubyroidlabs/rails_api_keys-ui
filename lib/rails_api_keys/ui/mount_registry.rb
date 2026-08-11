# frozen_string_literal: true

module RailsApiKeys
  module UI
    # Stores per-draw-helper options (owner resolution, authorize, etc.).
    # Route defaults only carry the mount name; procs live here.
    class MountRegistry
      def initialize
        @mounts = {}
      end

      def register(name, options)
        @mounts[name.to_s] = options.dup
      end

      def fetch(name)
        @mounts.fetch(name.to_s) do
          raise KeyError, "Unknown rails_api_keys_ui mount #{name.inspect}. " \
                          "Did routes reload without re-registering?"
        end
      end

      def clear!
        @mounts.clear
      end
    end
  end
end
