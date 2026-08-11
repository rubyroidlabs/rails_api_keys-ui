# frozen_string_literal: true

module RailsApiKeys
  module UI
    # HTML + JSON API key management (index / create / destroy).
    class ApiKeysController < ApplicationController
      before_action :set_api_key_owner
      before_action :set_api_key, only: :destroy

      def index
        authorize_api_key!(:index, RailsApiKeys::ApiKey)
        @api_keys = api_keys_scope.order(created_at: :desc)

        respond_to do |format|
          format.html
          format.json { render json: @api_keys.map { |key| serialize_key(key) } }
        end
      end

      def create
        authorize_api_key!(:create, RailsApiKeys::ApiKey.new(owner: @api_key_owner))

        api_key, raw_token = @api_key_owner.create_api_key!(
          name: api_key_params[:name],
          permission: api_key_params[:permission]
        )

        respond_to do |format|
          format.html do
            flash[raw_token_flash_key] = raw_token
            redirect_back_after_change notice: t(".created")
          end
          format.json do
            render json: serialize_key(api_key).merge(raw_token: raw_token), status: :created
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        respond_to do |format|
          format.html do
            redirect_back_after_change alert: e.record.errors.full_messages.join(", ")
          end
          format.json do
            render json: { errors: e.record.errors.full_messages }, status: :unprocessable_content
          end
        end
      end

      def destroy
        authorize_api_key!(:destroy, @api_key)
        @api_key.revoke!

        respond_to do |format|
          format.html do
            redirect_back_after_change notice: t(".revoked")
          end
          format.json { head :no_content }
        end
      end

      private

      def mount_options
        @mount_options ||= RailsApiKeys::UI.mounts.fetch(params[:rails_api_keys_ui_mount])
      end

      def set_api_key_owner
        @api_key_owner = resolve_owner(mount_options[:owner])
      end

      def resolve_owner(owner_option)
        case owner_option
        when nil, :current_user, "current_user"
          RailsApiKeys::UI.configuration.current_owner.call(self)
        when Proc
          owner_option.call(self)
        when Symbol, String
          resolve_named_owner(owner_option.to_s)
        else
          raise ArgumentError, "Unsupported rails_api_keys_ui owner: #{owner_option.inspect}"
        end
      end

      def resolve_named_owner(name)
        param_key = "#{name}_id"
        if params[param_key].present?
          name.camelize.constantize.find(params[param_key])
        elsif respond_to?(name, true)
          send(name)
        else
          raise ArgumentError,
                "Cannot resolve owner #{name.inspect}: missing params[#{param_key}] " \
                "and ##{name}"
        end
      end

      def set_api_key
        @api_key = api_keys_scope.find(params[:id])
      end

      def api_keys_scope
        @api_key_owner.api_keys.active
      end

      def api_key_params
        params.require(:api_key).permit(:name, :permission)
      end

      def raw_token_flash_key
        RailsApiKeys::UI.configuration.raw_token_flash_key
      end

      def redirect_back_after_change(**flash_options)
        redirect_back fallback_location: mount_index_path, allow_other_host: false, **flash_options
      end

      def mount_index_path
        path = request.path
        path = path.sub(%r{/[^/]+\z}, "") if action_name == "destroy"
        path
      end

      def authorize_api_key!(action, record)
        mount_auth = mount_options[:authorize]
        return mount_auth.call(self, action, record) if mount_auth

        config_auth = RailsApiKeys::UI.configuration.authorize
        return config_auth.call(self, action, record) if config_auth

        if defined?(Pundit)
          policy_class = RailsApiKeys::UI.configuration.policy_class.constantize
          query = :"#{action}?"
          user = respond_to?(:pundit_user, true) ? pundit_user : current_user
          Pundit.authorize(user, record, query, policy_class: policy_class)
        else
          true
        end
      end

      def serialize_key(api_key)
        {
          id: api_key.id,
          name: api_key.name,
          permission: api_key.permission,
          token_display_prefix: api_key.token_display_prefix,
          last_used_at: api_key.last_used_at,
          created_at: api_key.created_at,
          revoked_at: api_key.revoked_at
        }
      end
    end
  end
end
