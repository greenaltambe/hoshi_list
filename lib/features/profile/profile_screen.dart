import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/profile/providers/user_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
            radius: 50,
          ),
          const SizedBox(height: 16),
          Text(user.username, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    label: 'Total anime',
                    value: user.animeStats.total.toString(),
                  ),

                  _StatItem(
                    label: 'Days watched',
                    value: user.animeStats.daysWatched.toStringAsFixed(1),
                  ),

                  _StatItem(
                    label: 'Mean score',
                    value: user.animeStats.meanScore.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    label: 'Total manga',
                    value: user.mangaStats.total.toString(),
                  ),

                  _StatItem(
                    label: 'Chapters read',
                    value: user.mangaStats.chaptersRead.toString(),
                  ),

                  _StatItem(
                    label: 'Mean score',
                    value: user.mangaStats.meanScore.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
