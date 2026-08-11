# Contributing

Thanks for helping improve `rails_api_keys-ui`. This gem provides an optional management UI on top of [`rails_api_keys`](https://github.com/rubyroidlabs/rails_api_keys).

## Development setup

```bash
bundle install
bundle exec rspec
bin/rubocop
```

Specs boot `spec/dummy` (sqlite). Run both RSpec and RuboCop before opening a PR.

## Pull requests

1. Open an issue first for larger changes so we can agree on scope.
2. Keep the UI engine focused on key management (list/create/revoke) — no domain APIs.
3. Prefer single quotes and `# frozen_string_literal: true` on Ruby files.
4. Add or update RSpec coverage for behavior changes.
5. Update `CHANGELOG.md` under `[Unreleased]` when the public API or user-facing behavior changes.
6. Update `AGENTS.md` when the public API changes.

## Security

Do not report security vulnerabilities in public issues. See [SECURITY.md](./SECURITY.md).

## Code of conduct

Participation is covered by our [Code of Conduct](./CODE_OF_CONDUCT.md).
