# Repository Guidelines

## Project Structure & Module Organization
Rails 8.1 (Ruby 3.3.6) API-only service. Controllers live under `app/controllers/api/v1` grouped by domain (`auth`, `users`, `portfolio`, `blog`, `reading`, `travel`, `hire`), keeping request/response logic versioned. Models and callbacks stay in `app/models`; mailers and their templates live in `app/mailers` and `app/views`. Shared controller concerns go in `app/controllers/concerns`. Database schema and seeds are in `db/` (use `schema.rb` as the source of truth). Tests mirror the code layout in `test/` with fixtures in `test/fixtures`.

## Build, Test, and Development Commands
- Install deps: `bundle install`
- Setup DB (creates/migrates/seeds): `bin/rails db:setup`
- Run server: `bin/rails s` (defaults to Puma on port 3000)
- Console: `bin/rails console`
- Tests: `bin/rails test`
- Lint/format: `bundle exec rubocop`
- Security checks: `bundle exec brakeman`; dependency audit: `bundle exec bundler-audit`

## Coding Style & Naming Conventions
Follow RuboCop Rails Omakase rules (`.rubocop.yml`); keep 2-space indentation, single quotes, and snake_case methods/variables. Use module namespaces `Api::V1::<Domain>` for controllers and RESTful resource naming (`ProjectsController`, `PostsController`). Prefer strong parameters, early returns for guard clauses, and service objects only when controller actions get bulky. Keep responses JSON-ready and avoid embedding presentation logic in controllers.

## Testing Guidelines
Use Minitest (parallelized) with fixtures; name files `*_test.rb` and match the namespace of the code under test (e.g., `test/controllers/api/v1/blog/posts_controller_test.rb`). Write request tests for new endpoints and model tests for validations/callbacks. Add fixture data in `test/fixtures/*.yml` or build records inline; clean up any external state the test creates. Aim to cover error paths and authorization checks, not just happy paths.

## Commit & Pull Request Guidelines
Use imperative, concise commit subjects (≈50 chars) with context first: `Add V1 reading stats endpoint`, `Fix auth password reset expiry`. Group related changes per commit. For PRs, include a short summary, linked issue/ticket, test evidence (`bin/rails test`, `bundle exec rubocop`), and any API contract notes (new routes, response shapes). Add screenshots or sample JSON when changing responses.

## Security & Configuration Tips
Store secrets via Rails credentials (`bin/rails credentials:edit`) and keep `.env*` out of commits. Update allowed origins in `config/initializers/cors.rb` when frontends change. Run `brakeman` and `bundler-audit` before shipping sensitive auth work. Avoid checking in generated logs, `storage/` uploads, or database files.*** End Patch ***!
