import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoshi_list/core/pagination/paged.dart';

class _NumbersNotifier extends PagedNotifier<int> {
  static int failOnPage = -1;
  static final requested = <int>[];

  @override
  Future<PageResult<int>> fetchPage(int page) async {
    requested.add(page);
    if (page == failOnPage) throw Exception('boom');
    return PageResult(items: [page * 10, page * 10 + 1], hasNextPage: page < 3);
  }
}

final _numbers = AsyncNotifierProvider<_NumbersNotifier, PagedList<int>>(
  _NumbersNotifier.new,
);

void main() {
  late ProviderContainer container;

  setUp(() {
    _NumbersNotifier.failOnPage = -1;
    _NumbersNotifier.requested.clear();
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('loads the first page, then appends further pages', () async {
    final first = await container.read(_numbers.future);
    expect(first.items, [10, 11]);
    expect(first.hasNextPage, isTrue);

    await container.read(_numbers.notifier).loadMore();

    expect(container.read(_numbers).value!.items, [10, 11, 20, 21]);
  });

  test('stops requesting once the last page was loaded', () async {
    await container.read(_numbers.future);
    final notifier = container.read(_numbers.notifier);
    await notifier.loadMore();
    await notifier.loadMore();
    await notifier.loadMore(); // no page 4

    expect(_NumbersNotifier.requested, [1, 2, 3]);
    expect(container.read(_numbers).value!.hasNextPage, isFalse);
  });

  test('ignores concurrent loadMore calls', () async {
    await container.read(_numbers.future);
    final notifier = container.read(_numbers.notifier);

    await Future.wait([notifier.loadMore(), notifier.loadMore()]);

    expect(_NumbersNotifier.requested, [1, 2]);
  });

  test('a failed page keeps the loaded items and can be retried', () async {
    await container.read(_numbers.future);
    final notifier = container.read(_numbers.notifier);

    _NumbersNotifier.failOnPage = 2;
    await notifier.loadMore();

    var state = container.read(_numbers).value!;
    expect(state.items, [10, 11]);
    expect(state.loadMoreError, isNotNull);
    expect(state.isLoadingMore, isFalse);

    _NumbersNotifier.failOnPage = -1;
    await notifier.loadMore();

    state = container.read(_numbers).value!;
    expect(state.items, [10, 11, 20, 21]);
    expect(state.loadMoreError, isNull);
  });
}
