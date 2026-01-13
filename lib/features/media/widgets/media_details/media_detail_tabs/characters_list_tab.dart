import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/providers/character_details_provider.dart';
import 'package:hoshi_list/features/media/providers/character_list_provider.dart';
import 'package:markdown_widget/markdown_widget.dart';

class CharactersListTab extends ConsumerWidget {
  const CharactersListTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterList = ref.watch(mediaCharacterListProvider(mediaId));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: characterList.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            data: (characterList) => ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: characterList.length + 1,
              itemBuilder: (context, index) {
                if (index == characterList.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(mediaCharacterListProvider(mediaId).notifier)
                            .loadNextPage();
                      },
                      child: const Text('Load more'),
                    ),
                  );
                }
                final character = characterList[index];
                return ListTile(
                  leading: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      character.imageUrl,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(character.name),
                  subtitle: Text('Role: ${character.role}'),
                  onTap: () {
                    _showCharacterDetails(context, character);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showCharacterDetails(BuildContext context, character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final characterDetails = ref.watch(
                  mediaCharacterDetailsProvider(character.id),
                );
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Character Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          character
                              .imageUrl, // Use passed character img while loading details
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        character.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        character.role,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Divider(height: 32),

                      characterDetails.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                        error: (err, _) =>
                            Text('Could not load description: $err'),
                        data: (details) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              // Markdown Widget Configuration
                              MarkdownWidget(
                                data:
                                    details.description ??
                                    'No description available.',
                                shrinkWrap:
                                    true, // Vital when inside SingleChildScrollView
                                physics:
                                    const NeverScrollableScrollPhysics(), // Let parent scroll
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
