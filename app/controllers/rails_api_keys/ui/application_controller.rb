# frozen_string_literal: true

module RailsApiKeys
  module UI
    # Inherits the host ApplicationController (Devise session, layout, CSRF).
    # Override via +config.parent_controller+ only when generating a host controller.
    class ApplicationController < ::ApplicationController
    end
  end
end
