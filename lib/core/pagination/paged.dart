import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One page as returned by a repository.
class PageResult<T> {
  const PageResult({required this.items, required this.hasNextPage});

  final List<T> items;
  final bool hasNextPage;
}

/// Everything loaded so far plus what is needed to fetch the next page.
class PagedList<T> {
  const PagedList({
    required this.items,
    required this.hasNextPage,
    required this.nextPage,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<T> items;
  final bool hasNextPage;
  final int nextPage;
  final bool isLoadingMore;

  /// Set when fetching a further page failed. The pages already loaded are
  /// kept so the user doesn't lose their scroll position.
  final Object? loadMoreError;

  PagedList<T> copyWith({
    List<T>? items,
    bool? hasNextPage,
    int? nextPage,
    bool? isLoadingMore,
    Object? loadMoreError,
  }) {
    return PagedList(
      items: items ?? this.items,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      nextPage: nextPage ?? this.nextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError,
    );
  }
}

/// Base class for infinite lists. Subclasses only say how to fetch page N.
abstract class PagedNotifier<T> extends AsyncNotifier<PagedList<T>> {
  /// Fetches a 1-based page.
  Future<PageResult<T>> fetchPage(int page);

  @override
  Future<PagedList<T>> build() async {
    final first = await fetchPage(1);
    return PagedList(
      items: first.items,
      hasNextPage: first.hasNextPage,
      nextPage: 2,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || current.isLoadingMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await fetchPage(current.nextPage);
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...page.items],
          hasNextPage: page.hasNextPage,
          nextPage: current.nextPage + 1,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }
}
