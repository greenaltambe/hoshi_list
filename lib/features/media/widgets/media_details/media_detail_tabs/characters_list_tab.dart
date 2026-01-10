import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/providers/character_list_provider.dart';

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
              itemCount: characterList.length,
              itemBuilder: (context, index) {
                final character = characterList[index];
                return ListTile(
                  leading: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(character.imageUrl),
                  ),
                  title: Text(character.name),
                  subtitle: Text('Role: ${character.role}'),
                );
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            ref
                .read(mediaCharacterListProvider(mediaId).notifier)
                .loadNextPage();
          },
          child: const Text('Load more'),
        ),
      ],
    );
  }
}
