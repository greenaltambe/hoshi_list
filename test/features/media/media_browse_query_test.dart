import 'package:flutter_test/flutter_test.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

void main() {
  test('queries are value-equal so provider families can cache them', () {
    const a = MediaBrowseQuery(
      type: MediaType.anime,
      filters: MediaFilters(format: MediaFormat.tv),
    );
    const b = MediaBrowseQuery(
      type: MediaType.anime,
      filters: MediaFilters(format: MediaFormat.tv),
    );

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(a.copyWith(sort: MediaSort.scoreDesc)));
  });

  test('copyWith keeps filters (regression: paging used to drop them)', () {
    const query = MediaBrowseQuery(
      type: MediaType.anime,
      filters: MediaFilters(status: MediaStatus.releasing),
    );

    expect(
      query.copyWith(searchText: 'x').filters.status,
      MediaStatus.releasing,
    );
  });
}
