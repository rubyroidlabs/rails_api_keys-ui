# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0/).

## [Unreleased]

## [0.3.0] - 2026-11-25

### Added

- Optional `allowed_ips` field in create modal (HTML + JSON) and display on active key rows
- `PATCH` `update` route, controller action, `ApiKeyPolicy#update?`, and "Edit IPs" modal to update `allowed_ips` on existing keys
- Optional `update_path:` parameter on `rails_api_keys_ui_panel` (defaults to `destroy_path`)

## [0.2.0] - 2026-08-11

### Added

- Mountable `rails_api_keys_ui` draw helper (nested or flat mounts, explicit owner vs context)
- `RailsApiKeys::UI::ApiKeysController` — HTML + JSON `index` / `create` / `destroy`
- Tailwind-compatible markup + Stimulus defaults (`modal` / `clipboard`) with reveal-once + copy UX
- Shipped scoped stylesheet (`rails_api_keys/ui.css`) inlined by the panel; `config.include_stylesheet` to opt out
- CSS variables `--rak-ui-primary-600` / `--rak-ui-primary-700` for brand overrides
- Embeddable panel helper/partial
- Generators: `install`, `controllers`, `views`, `locales`
- Soft Pundit integration (default owner policy; no-op authorize when Pundit is absent)
- Configurable `current_owner`, `parent_controller`, flash key, `include_stylesheet`
- HTML redirects via `redirect_back` (fallback: mount index)

[Unreleased]: https://github.com/rubyroidlabs/rails_api_keys-ui/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/rubyroidlabs/rails_api_keys-ui/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/rubyroidlabs/rails_api_keys-ui/releases/tag/v0.2.0
