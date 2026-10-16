# HoshiList

A Flutter client for [AniList](https://anilist.co): browse and search anime and manga, see details, and manage your own list.

## Running

```sh
flutter pub get
flutter run
```

Logging in opens AniList in the browser and returns through the `hoshilist://auth` deep link. To use your own AniList API client, register one with the redirect URL `hoshilist://auth` and run with:

```sh
flutter run --dart-define=ANILIST_CLIENT_ID=<your id>
```

## Checks

```sh
flutter analyze
flutter test
```

## Documentation

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): how the code is organised and why.
- [docs/DEVELOPMENT_GUIDE.md](docs/DEVELOPMENT_GUIDE.md): recipes for adding features, plus a prioritised improvement backlog.
