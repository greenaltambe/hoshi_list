import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/auth/auth_controller.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/features/profile/presentation/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView(
      value: ref.watch(currentUserProvider),
      onRetry: () => ref.invalidate(currentUserProvider),
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl),
                radius: 50,
              ),
              const SizedBox(height: 16),
              Text(user.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: ref.read(authControllerProvider.notifier).logout,
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ],
          ),
        );
      },
    );
  }
}
