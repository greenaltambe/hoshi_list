# Development guide

## Daily loop

```sh
flutter analyze && flutter test
```

Run both before every commit. Lints are strict (`strict-casts`, `strict-raw-types`, `avoid_print`, `always_use_package_imports`, `prefer_single_quotes`); keep them at zero warnings.

## Recipe: add a new AniList query (e.g. "airing schedule")

1. **Domain**: add the model (and any enum implementing `ApiEnum`) under `features/<feature>/domain/`.
2. **Query**: add the GraphQL document to `features/<feature>/data/<feature>_queries.dart`. Reuse `mediaSummaryFragment` when you need card-sized media.
3. **Mapper**: add a pure `mapX(Json)` function in the feature's `*_mappers.dart`.
4. **Repository**: add a method that calls `_client.query(...)` and wraps the mapping in `guardParse(...)`.
5. **Test**: feed the mapper a canned map in `test/features/<feature>/` (see `media_repository_test.dart`).
6. **Provider**: expose it in `presentation/` (`FutureProvider.family`, or a `PagedNotifier` for lists).
7. **UI**: render with `AsyncValueView`, `MediaCarousel`, `PagedListView` or `MediaGrid`. Do not hand-write loading/error branches.

Use the AniList GraphQL explorer at <https://anilist.co/graphiql> to prototype the query first.

## Recipe: add a screen or tab

- Screen in `features/<feature>/presentation/`. Add a `_Destination` in `features/shell/presentation/app_shell.dart` for a bottom-nav tab.
- Navigation is plain `Navigator.push`; give a screen a static `open(context, ...)` helper like `MediaDetailsScreen.open`.

## Recipe: add a new paged list

```dart
class FooNotifier extends PagedNotifier<Foo> {
  FooNotifier(this.id);
  final int id;
  @override
  Future<PageResult<Foo>> fetchPage(int page) =>
      ref.read(fooRepositoryProvider).foos(id, page);
}

final fooProvider = AsyncNotifierProvider.family<FooNotifier, PagedList<Foo>, int>(
  FooNotifier.new,
);
```

Then `PagedListView<Foo>(value: ref.watch(fooProvider(id)), onLoadMore: ..., onRetry: ...)`.

## Rules worth keeping

- No JSON, `http`, or GraphQL in widgets or providers.
- No Flutter imports in `domain/`. Colours and icons for a domain enum live in `presentation/` as an extension (see `genre_style.dart`).
- Every enum that maps to AniList carries its `apiValue`; never derive API strings from `enum.name`.
- Never log tokens or response bodies.
- Magic strings and URLs go in `AppConfig`.
- If a widget file passes ~300 lines, split it into private widgets in the same folder.

## Known gaps and a suggested order of work

**1. Make it trustworthy (small, high value)**
- Scores: the list and edit sheet use AniList's 0-100 scale. Read the viewer's `mediaListOptions.scoreFormat` and display/edit in the user's own format (10-point, 5-star, ...).
- Quick progress: add a "+1 episode" button on `LibraryEntryCard` using `LibraryActions.save`.
- Home "in progress" shows the media; show the user's progress and the next episode on it.
- Cache images with `cached_network_image` (fewer re-downloads, placeholders, error widgets); today `Image.network` has no placeholder.

**2. Replace the placeholder**
- `features/home/data/placeholder_activity.dart` is fake. Build `ActivityRepository` on AniList's `Page { activities(...) }` query, then delete the placeholder. A `PagedNotifier` fits.

**3. Finish unfinished features**
- Profile stats (counts, mean score, days watched) from `Viewer.statistics`.
- Filter by genre/tags in `MediaFilters` (`genre_in`, `tag_in`).
- Search for characters, staff and users (the search screen only covers media today).
- Favourites toggle (`ToggleFavourite` mutation) and delete-from-list (`DeleteMediaListEntry`).

**4. Engineering upgrades**
- Replace `Navigator.push` with `go_router` once deep links to media pages (`hoshilist://media/123`) are wanted.
- Offline cache: persist the last library and browse results (e.g. `drift` or `isar`) and show them while refreshing.
- Add `freezed` / `json_serializable` if the models grow; the hand-written `==` in `MediaBrowseQuery` is the only boilerplate today.
- Add a CI workflow running `flutter analyze` and `flutter test`.
- Widget tests with golden files for `MediaPosterCard`, `LibraryEntryCard`, and the edit sheet.
- Localisation (`flutter_localizations` + ARB files); user-facing strings are currently inline.
- Token expiry: AniList tokens last a year. A 401 logs the user out; consider a friendlier "session expired" message on the login screen.

**5. Release hygiene**
- Set the real application id / app name / icons in `android/` and `ios/`.
- Add a privacy note and, if you publish, your own AniList API client id via `--dart-define`.
