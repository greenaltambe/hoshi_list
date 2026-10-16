import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/home/presentation/widgets/activity_section.dart';
import 'package:hoshi_list/features/library/domain/media_list_status.dart';
import 'package:hoshi_list/features/library/presentation/library_providers.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _InProgressCarousel(type: MediaType.anime),
          SizedBox(height: 16),
          _InProgressCarousel(type: MediaType.manga),
          SizedBox(height: 16),
          ActivitySection(),
        ],
      ),
    );
  }
}

/// The user's "currently watching/reading" entries.
class _InProgressCarousel extends ConsumerWidget {
  const _InProgressCarousel({required this.type});

  final MediaType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref
        .watch(libraryProvider(type))
        .whenData(
          (groups) => [
            for (final group in groups)
              if (!group.isCustomList &&
                  group.status == MediaListStatus.current)
                for (final entry in group.entries) entry.media,
          ],
        );

    return MediaCarousel(
      title: '${type.label} in progress',
      items: items,
      onRetry: () => ref.invalidate(libraryProvider(type)),
    );
  }
}
