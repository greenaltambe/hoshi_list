import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/error/app_exception.dart';

/// Renders an [AsyncValue] with consistent loading and error states.
/// Pass [onRetry] to show a retry button on error.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: true,
      data: data,
      loading: () =>
          loading ?? const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorView(error: error, onRetry: onRetry),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: colors.error),
            const SizedBox(height: 8),
            Text(
              describeError(error),
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.error),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
