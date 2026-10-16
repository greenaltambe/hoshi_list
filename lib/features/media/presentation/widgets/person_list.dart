import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/pagination/paged.dart';
import 'package:hoshi_list/core/widgets/paged_list_view.dart';
import 'package:hoshi_list/features/media/domain/media_person.dart';
import 'package:hoshi_list/features/media/presentation/widgets/person_details_sheet.dart';

/// List used by both the Characters and Staff tabs.
class PersonList extends StatelessWidget {
  const PersonList({
    super.key,
    required this.people,
    required this.onLoadMore,
    required this.onRetry,
    required this.detailsProviderFor,
  });

  final AsyncValue<PagedList<MediaPerson>> people;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final FutureProvider<MediaPerson> Function(int id) detailsProviderFor;

  @override
  Widget build(BuildContext context) {
    return PagedListView<MediaPerson>(
      value: people,
      onLoadMore: onLoadMore,
      onRetry: onRetry,
      itemBuilder: (context, person) => ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            person.imageUrl,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(person.name),
        subtitle: person.role == null ? null : Text(person.role!),
        onTap: () => showPersonDetailsSheet(
          context,
          person: person,
          details: detailsProviderFor(person.id),
        ),
      ),
    );
  }
}
