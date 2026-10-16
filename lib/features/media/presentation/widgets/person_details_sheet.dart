import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/core/widgets/sheet_drag_handle.dart';
import 'package:hoshi_list/features/media/domain/media_person.dart';
import 'package:markdown_widget/markdown_widget.dart';

/// Bottom sheet for a character or staff member. [person] (from the list) is
/// shown immediately; [details] supplies the description once loaded.
Future<void> showPersonDetailsSheet(
  BuildContext context, {
  required MediaPerson person,
  required FutureProvider<MediaPerson> details,
}) {
  return showDraggableSheet<void>(
    context,
    builder: (context, scrollController) => Consumer(
      builder: (context, ref, _) {
        final theme = Theme.of(context);
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SheetDragHandle(),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  person.imageUrl,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                person.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (person.role != null) ...[
                const SizedBox(height: 8),
                Text(person.role!, style: theme.textTheme.labelLarge),
              ],
              const Divider(height: 32),
              AsyncValueView(
                value: ref.watch(details),
                loading: const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
                data: (details) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    MarkdownWidget(
                      data: details.description ?? 'No description available.',
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
