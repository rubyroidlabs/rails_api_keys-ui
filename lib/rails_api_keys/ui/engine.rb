# frozen_string_literal: true

require "rails_api_keys/ui/route_mapper"

module RailsApiKeys
  module UI
    class Engine < ::Rails::Engine
      isolate_namespace RailsApiKeys::UI

      initializer "rails_api_keys_ui.inflections", before: :set_autoload_paths do
        ActiveSupport::Inflector.inflections(:en) do |inflect|
          inflect.acronym "UI"
        end
      end

      initializer "rails_api_keys_ui.routes", before: :add_routing_paths do
        ActionDispatch::Routing::Mapper.include(RailsApiKeys::UI::RouteMapper)
      end

      initializer "rails_api_keys_ui.helpers" do
        ActiveSupport.on_load(:action_controller_base) do
          helper_path = RailsApiKeys::UI::Engine.root.join("app/helpers/rails_api_keys/ui/api_keys_helper.rb")
          require helper_path.to_s unless defined?(RailsApiKeys::UI::ApiKeysHelper)
          helper RailsApiKeys::UI::ApiKeysHelper
        end
      end

      initializer "rails_api_keys_ui.assets" do |app|
        next unless app.config.respond_to?(:assets)

        app.config.assets.paths << root.join("app/javascript")
        app.config.assets.paths << root.join("app/assets/stylesheets")
        if app.config.assets.respond_to?(:precompile)
          app.config.assets.precompile << "rails_api_keys/ui.css"
        end
      end
    end
  end
end
