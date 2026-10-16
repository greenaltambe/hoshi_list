# Architecture

HoshiList is **feature-first** with a small **layered** structure inside each feature, using Riverpod for state and dependency injection.

```
lib/
  main.dart                  runApp(ProviderScope(App))
  app/app.dart               MaterialApp, theme, login-vs-shell gate
  core/                      feature-agnostic building blocks
    auth/                    AuthRepository (storage, browser, deep link) + AuthController (token state)
    config/app_config.dart   URLs, client id, scheme: the only place with magic strings
    error/app_exception.dart sealed AppException + describeError()
    network/anilist_client.dart  GraphQL transport: send document, get `data` or an AppException
    pagination/paged.dart    PageResult, PagedList, PagedNotifier (infinite scroll base class)
    theme/, utils/, widgets/ theme, JSON/date helpers, shared widgets (AsyncValueView, ...)
  features/
    <feature>/
      domain/                plain Dart models and enums, no Flutter, no JSON
      data/                  GraphQL documents, JSON mappers, repository
      presentation/          providers, screens, widgets
    auth/ browse/ home/ library/ media/ profile/ search/ shell/
```

## Layers and the dependency rule

```
presentation  ->  data (repository)  ->  core/network
      \               |
       +------> domain <------+
```

- **domain** depends on nothing app-specific (only `core/utils` for the `ApiEnum` helper). It must not import Flutter widgets, `http`, or Riverpod.
- **data** turns AniList JSON into domain models. `XRepository` is the only thing that knows queries and mappers; mappers are pure functions and are unit-tested with plain maps.
- **presentation** talks to repositories through Riverpod providers and never sees JSON, `http.Response`, or GraphQL strings.
- **core** never imports from `features/`.

Features may import another feature's `domain` (e.g. `library` uses `MediaSummary`). `media` opens the list-entry editor from `library/presentation`, which is the one intentional UI dependency between features.

## Data flow

```
Widget --ref.watch--> Provider --> Repository --> AnilistClient --> AniList
                                       |
                                  mapper (JSON -> domain model)
```

Errors travel the same way as values: the client throws `NetworkException` / `UnauthorizedException` / `ApiException`, repositories wrap malformed payloads in `ParsingException` via `guardParse`, and the UI renders them with `AsyncValueView` (which also offers a retry button).

## State management conventions

| Need | Use |
| --- | --- |
| One-shot read, cached per argument | `FutureProvider.family` |
| Infinite list | subclass `PagedNotifier<T>`, implement `fetchPage(page)` |
| Value that changes on user action | `AsyncNotifier` / `Notifier` (see `AuthController`) |
| Write + refresh | a small `*Actions` class (see `LibraryActions`) that calls the repository, then `ref.invalidate`s |

Provider family arguments must have value equality (`MediaBrowseQuery`, records, ints). Public data providers read the token lazily; user-specific providers (`currentUserProvider`, `libraryProvider`) depend on the auth state, so logging out cannot leave another user's data on screen.

## Auth

AniList's implicit grant returns `hoshilist://auth#access_token=...`. `AuthRepository.redirectedTokens()` parses those links, `AuthController` stores the token in secure storage and publishes it, and `App` switches between `LoginScreen` and `AppShell`. A 401 from the API calls `AuthController.logout()` automatically. Tokens are never logged.

## Testing

- `test/core`: transport error mapping and the pagination base class.
- `test/features/*`: repositories and mappers against canned JSON, query-variable building.
- `test/app`: login gate, logout, and a smoke test of the logged-in shell with a stubbed `AnilistClient`.

Tests build a real `AnilistClient` around `http`'s `MockClient`, or override a provider. No test hits the network.
