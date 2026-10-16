import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';
import 'package:hoshi_list/features/media/presentation/widgets/person_list.dart';

class CharactersTab extends ConsumerWidget {
  const CharactersTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PersonList(
      people: ref.watch(mediaCharactersProvider(mediaId)),
      onLoadMore: ref.read(mediaCharactersProvider(mediaId).notifier).loadMore,
      onRetry: () => ref.invalidate(mediaCharactersProvider(mediaId)),
      detailsProviderFor: characterDetailsProvider.call,
    );
  }
}
