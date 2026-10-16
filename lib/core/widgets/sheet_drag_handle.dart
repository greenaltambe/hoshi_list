import 'package:flutter/material.dart';

class SheetDragHandle extends StatelessWidget {
  const SheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Shows [builder]'s content in a draggable modal bottom sheet. The builder
/// receives the scroll controller the content must attach to.
Future<T?> showDraggableSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext, ScrollController) builder,
  double initialSize = 0.6,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialSize,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: builder,
    ),
  );
}
