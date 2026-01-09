import 'package:flutter/material.dart';

/// A widget to display an error message in a horizontal media list.
/// Used in scenarios where fetching media fails.
class ErrorHorizontalMediaList extends StatelessWidget {
  const ErrorHorizontalMediaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 8),
          Text(
            'An error occurred while fetching items.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
