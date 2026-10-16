import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/pagination/paged.dart';
import 'package:hoshi_list/features/media/data/media_repository.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/domain/media_person.dart';
import 'package:hoshi_list/features/media/domain/media_review.dart';

// ---- Single-shot data ------------------------------------------------------

final mediaDetailsProvider = FutureProvider.family<MediaDetails, int>(
  (ref, mediaId) => ref.watch(mediaRepositoryProvider).details(mediaId),
);

final mediaRelationsProvider = FutureProvider.family<List<MediaRelation>, int>(
  (ref, mediaId) => ref.watch(mediaRepositoryProvider).relations(mediaId),
);

final characterDetailsProvider = FutureProvider.family<MediaPerson, int>(
  (ref, id) => ref.watch(mediaRepositoryProvider).characterDetails(id),
);

final staffDetailsProvider = FutureProvider.family<MediaPerson, int>(
  (ref, id) => ref.watch(mediaRepositoryProvider).staffDetails(id),
);

// ---- Paged data ------------------------------------------------------------

class MediaListNotifier extends PagedNotifier<MediaSummary> {
  MediaListNotifier(this.query);

  final MediaBrowseQuery query;

  @override
  Future<PageResult<MediaSummary>> fetchPage(int page) =>
      ref.read(mediaRepositoryProvider).browse(query, page);
}

/// Browse / search results for a query.
final mediaListProvider =
    AsyncNotifierProvider.family<
      MediaListNotifier,
      PagedList<MediaSummary>,
      MediaBrowseQuery
    >(MediaListNotifier.new);

class MediaRecommendationsNotifier extends PagedNotifier<MediaSummary> {
  MediaRecommendationsNotifier(this.mediaId);

  final int mediaId;

  @override
  Future<PageResult<MediaSummary>> fetchPage(int page) =>
      ref.read(mediaRepositoryProvider).recommendations(mediaId, page);
}

final mediaRecommendationsProvider =
    AsyncNotifierProvider.family<
      MediaRecommendationsNotifier,
      PagedList<MediaSummary>,
      int
    >(MediaRecommendationsNotifier.new);

class MediaCharactersNotifier extends PagedNotifier<MediaPerson> {
  MediaCharactersNotifier(this.mediaId);

  final int mediaId;

  @override
  Future<PageResult<MediaPerson>> fetchPage(int page) =>
      ref.read(mediaRepositoryProvider).characters(mediaId, page);
}

final mediaCharactersProvider =
    AsyncNotifierProvider.family<
      MediaCharactersNotifier,
      PagedList<MediaPerson>,
      int
    >(MediaCharactersNotifier.new);

class MediaStaffNotifier extends PagedNotifier<MediaPerson> {
  MediaStaffNotifier(this.mediaId);

  final int mediaId;

  @override
  Future<PageResult<MediaPerson>> fetchPage(int page) =>
      ref.read(mediaRepositoryProvider).staff(mediaId, page);
}

final mediaStaffProvider =
    AsyncNotifierProvider.family<
      MediaStaffNotifier,
      PagedList<MediaPerson>,
      int
    >(MediaStaffNotifier.new);

class MediaReviewsNotifier extends PagedNotifier<MediaReview> {
  MediaReviewsNotifier(this.mediaId);

  final int mediaId;

  @override
  Future<PageResult<MediaReview>> fetchPage(int page) =>
      ref.read(mediaRepositoryProvider).reviews(mediaId, page);
}

final mediaReviewsProvider =
    AsyncNotifierProvider.family<
      MediaReviewsNotifier,
      PagedList<MediaReview>,
      int
    >(MediaReviewsNotifier.new);
