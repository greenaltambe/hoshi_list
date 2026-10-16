import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/features/library/presentation/library_providers.dart';
import 'package:hoshi_list/features/library/presentation/widgets/library_entry_card.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  MediaType _type = MediaType.anime;

  @override
  Widget build(BuildContext context) {
    final library = ref.watch(libraryProvider(_type));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SegmentedButton<MediaType>(
            showSelectedIcon: false,
            segments: [
              for (final type in MediaType.values)
                ButtonSegment(value: type, label: Text(type.label)),
            ],
            selected: {_type},
            onSelectionChanged: (selection) =>
                setState(() => _type = selection.first),
          ),
        ),
        Expanded(
          child: AsyncValueView(
            value: library,
            onRetry: () => ref.invalidate(libraryProvider(_type)),
            data: (groups) {
              if (groups.isEmpty) {
                return const Center(
                  child: Text('Your list is empty. Start adding some media!'),
                );
              }
              return DefaultTabController(
                key: ValueKey(_type),
                length: groups.length,
                child: Column(
                  children: [
                    TabBar(
                      tabAlignment: TabAlignment.center,
                      isScrollable: true,
                      splashBorderRadius: BorderRadius.circular(16),
                      tabs: [for (final group in groups) Tab(text: group.name)],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          for (final group in groups)
                            RefreshIndicator(
                              onRefresh: () =>
                                  ref.refresh(libraryProvider(_type).future),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: group.entries.length,
                                itemBuilder: (context, index) =>
                                    LibraryEntryCard(
                                      entry: group.entries[index],
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
