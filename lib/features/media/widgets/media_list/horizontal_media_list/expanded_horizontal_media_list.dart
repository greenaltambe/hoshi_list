import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/browse/providers/media_list_provider.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/error_horizontal_media_list.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/expanded_media_list_card.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/loading_horizontal_media_list.dart';
import 'package:hoshi_list/features/media/widgets/media_list/grid_media_list/anime_manga_grid.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class ExpandedHorizontalMediaList extends ConsumerWidget {
  const ExpandedHorizontalMediaList({
    super.key,
    required this.query,
    required this.title,
  });

  final MediaQueryAL query;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(mediaListProvider(query));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The top row with title and arrow for more
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Material(
            color: Colors.transparent, // keeps background clean
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        AnimeMangaGrid(query: query, title: title),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ),

        items.when(
          loading: () => LoadingHorizontalMediaList(),
          error: (error, stackTrace) => ErrorHorizontalMediaList(),
          data: (items) {
            if (items.isEmpty) {
              return SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    'No items to display.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: 300,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 6,
                  itemBuilder: (context, index) => SizedBox(
                    width: 300,
                    child: ExpandedMediaListCard(item: items[index]),
                  ),
                  scrollDirection: Axis.horizontal,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
