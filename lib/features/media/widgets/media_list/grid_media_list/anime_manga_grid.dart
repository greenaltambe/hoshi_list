import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/browse/providers/media_list_provider.dart';
import 'package:hoshi_list/features/media/widgets/media_list/grid_media_list/filter_sheet.dart';
import 'package:hoshi_list/features/media/widgets/media_list/media_list_card.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class AnimeMangaGrid extends ConsumerStatefulWidget {
  const AnimeMangaGrid({super.key, required this.query, required this.title});

  final MediaQueryAL query;
  final String title;

  @override
  ConsumerState<AnimeMangaGrid> createState() => _AnimeMangaGridState();
}

class _AnimeMangaGridState extends ConsumerState<AnimeMangaGrid> {
  late MediaQueryAL _currentQuery;

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(mediaListProvider(_currentQuery));
    final notifier = ref.read(mediaListProvider(_currentQuery).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(34),
          child: _AppBarBottom(
            showSortOptions: () => _showSortOptions(context),
          ),
        ),
      ),
      body: mediaState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        data: (items) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >
                  scrollInfo.metrics.maxScrollExtent * 0.9) {
                notifier.loadNextPage();
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3.5,
                  mainAxisSpacing: 16,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(child: MediaListCard(item: item));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showSortOptions(BuildContext context) async {
    final newQuery = await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      context: context,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) {
          return FilterSheet(
            currentQuery: _currentQuery,
            scrollController: scrollController,
          );
        },
      ),
    );

    if (newQuery != null && newQuery != _currentQuery) {
      setState(() {
        _currentQuery = newQuery;
      });
    }
  }
}

class _AppBarBottom extends StatelessWidget {
  const _AppBarBottom({this.showSortOptions});

  final void Function()? showSortOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                avatar: Icon(Icons.filter_list),
                label: Text('Filters'),
                onSelected: (_) {
                  if (showSortOptions != null) {
                    showSortOptions!();
                  }
                },
              ),
            ],
          ),
        ),
        Container(color: Theme.of(context).dividerColor, height: 1.0),
      ],
    );
  }
}
