# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.action_controller.include_all_helpers = false
    config.autoload_lib(ignore: %w[assets tasks])
    config.generators.system_tests = nil
    config.secret_key_base = "dummy_secret_key_base_for_rails_api_keys_ui_tests"
  end
end
