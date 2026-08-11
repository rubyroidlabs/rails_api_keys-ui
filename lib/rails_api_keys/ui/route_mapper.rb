# frozen_string_literal: true

module RailsApiKeys
  module UI
    # Adds +rails_api_keys_ui+ to the host routes DSL.
    module RouteMapper
      # Draws +index+/+create+/+destroy+ API key routes for one owner mount.
      #
      # @param options [Hash]
      # @option options [Symbol, String, Proc] :owner key owner resolution
      #   (:current_user, :company, or callable)
      # @option options [Proc] :authorize optional per-mount authorize override
      # @option options [String] :controller host or engine controller
      # @option options [String] :path URL path segment (default "api_keys")
      # @option options [String, Symbol] :name mount registry key
      def rails_api_keys_ui(options = {})
        opts = options.dup
        mount_name = (opts.delete(:name) || default_rails_api_keys_ui_mount_name).to_s
        owner = opts.key?(:owner) ? opts.delete(:owner) : :current_user
        authorize = opts.delete(:authorize)
        controller = opts.delete(:controller) || "rails_api_keys/ui/api_keys"
        path = opts.delete(:path) || "api_keys"
        as = opts.delete(:as)

        RailsApiKeys::UI.mounts.register(
          mount_name,
          owner: owner,
          authorize: authorize
        )

        resource_options = {
          only: %i[index create destroy],
          controller: controller,
          path: path,
          defaults: { rails_api_keys_ui_mount: mount_name }
        }
        resource_options[:as] = as if as

        resources :api_keys, **resource_options, **opts
      end

      private

      def default_rails_api_keys_ui_mount_name
        scope = @scope
        parts = []
        parts << scope[:module] if scope[:module]
        parts << scope[:as] if scope[:as]
        parts << scope[:path] if scope[:path].present? && scope[:path] != "/"
        parts << "api_keys"
        parts.compact.join("_").gsub(%r{[/\-]}, "_").gsub(/__+/, "_")
      end
    end
  end
end
