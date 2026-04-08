# Warpy - Agent Guidelines

## What Warpy Is

Warpy is an EVE ESI API client library for Nim. It handles making typed, safe API calls to ESI and returning structured Nim objects.

## Auth Boundary

Warpy accepts an access token and attaches it to requests. That's it.

- **Warpy's responsibility:** Accept a token, add the `Authorization: Bearer` header, make the request, return typed responses.
- **Consumer's responsibility:** OAuth flow, token storage, token refresh, scope management.

The `tests/manual_oauth.nim` tool exists as both a test harness and a reference implementation for how consuming projects can handle the OAuth side.

## Endpoint Coverage

- **Public endpoints (no auth):** Fully implemented with typed modules and live API tests.
- **Authenticated endpoints:** Warpy needs to support passing an access token through `core.nim`'s `get`/`post` procs, then typed modules can be added for each authenticated endpoint group.

## Conventions

- One module per endpoint group in `src/warpy/`.
- One test file per module in `tests/`.
- Types are `ref object` with `Option[T]` for nullable fields.
- All procs accept `ifNoneMatch` for ETag caching.
- Register every new proc in `src/mapping.nim` and `src/warpy.nim`.
- Target the latest ESI API version (`endpointVersion = latest`).
- Only implement safe read (GET) endpoints for authenticated APIs unless explicitly asked.
