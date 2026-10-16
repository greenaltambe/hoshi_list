import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';
import 'package:hoshi_list/features/media/presentation/widgets/person_list.dart';

class StaffTab extends ConsumerWidget {
  const StaffTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PersonList(
      people: ref.watch(mediaStaffProvider(mediaId)),
      onLoadMore: ref.read(mediaStaffProvider(mediaId).notifier).loadMore,
      onRetry: () => ref.invalidate(mediaStaffProvider(mediaId)),
      detailsProviderFor: staffDetailsProvider.call,
    );
  }
}
