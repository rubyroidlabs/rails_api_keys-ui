# rails_api_keys-ui — Agent Guide

Optional Rails engine UI for [`rails_api_keys`](https://github.com/rubyroidlabs/rails_api_keys).

## Stack

- Gem name: `rails_api_keys-ui` (require: `rails_api_keys/ui` or `rails_api_keys_ui`)
- Module: `RailsApiKeys::UI`
- Draw helper mounts host routes; engine ships controller, views, Stimulus, locales, scoped CSS

## Architecture

**In this gem**

- `rails_api_keys_ui` route mapper + mount registry (`owner`, `authorize`)
- `RailsApiKeys::UI::ApiKeysController` — HTML + JSON
- Tailwind-compatible markup + shipped scoped CSS (`config.include_stylesheet`)
- Host `modal` / `clipboard` Stimulus controllers (install generator can copy examples)
- Soft Devise/Pundit defaults; generators for controllers/views/locales

**Not in this gem**

- Token model/auth (see `rails_api_keys`)
- Host session auth frameworks beyond defaults
- Domain business APIs
- Host Tailwind (optional; gem ships prebuilt CSS for its utility classes)

## Critical rules

- Raw token only via flash (HTML) or create JSON body — never list it again
- Index shows active keys only
- Prefer single quotes; `# frozen_string_literal: true`
- Run `bundle exec rspec` and `bundle exec rubocop` after non-trivial changes

## Commands

```bash
bundle install
bundle exec rspec
bin/rubocop
```
