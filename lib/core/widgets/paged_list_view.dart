import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/error/app_exception.dart';
import 'package:hoshi_list/core/pagination/paged.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';

/// A vertical, infinitely scrolling list backed by a [PagedNotifier] state.
class PagedListView<T> extends StatelessWidget {
  const PagedListView({
    super.key,
    required this.value,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.onRetry,
    this.emptyText = 'Nothing to show.',
  });

  final AsyncValue<PagedList<T>> value;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return AsyncValueView(
      value: value,
      onRetry: onRetry,
      data: (paged) {
        if (paged.items.isEmpty) return Center(child: Text(emptyText));

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200 &&
                paged.loadMoreError == null) {
              onLoadMore();
            }
            return false;
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: paged.items.length + 1,
            itemBuilder: (context, index) {
              if (index < paged.items.length) {
                return itemBuilder(context, paged.items[index]);
              }
              return _Footer(paged: paged, onRetry: onLoadMore);
            },
          ),
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.paged, required this.onRetry});

  final PagedList<Object?> paged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (paged.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(describeError(paged.loadMoreError!)),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (paged.hasNextPage) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return const SizedBox(height: 16);
  }
}
