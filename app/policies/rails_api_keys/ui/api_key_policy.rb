# frozen_string_literal: true

module RailsApiKeys
  module UI
    # Default Pundit policy: Devise +current_user+ may manage their own keys.
    class ApiKeyPolicy
      attr_reader :user, :record

      def initialize(user, record)
        @user = user
        @record = record
      end

      def index?
        user.present?
      end

      def create?
        user.present? && owner_matches_user?
      end

      def destroy?
        user.present? && owner_matches_user?
      end

      class Scope
        def initialize(user, scope)
          @user = user
          @scope = scope
        end

        def resolve
          return @scope.none unless @user

          @scope.where(owner: @user)
        end
      end

      private

      def owner_matches_user?
        owner = record.respond_to?(:owner) ? record.owner : nil
        return true if owner.nil?

        owner == user
      end
    end
  end
end
