import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/widgets/horizontal_list.dart';
import 'package:hoshi_list/features/home/providers/media_in_progress_provider.dart';
import 'package:hoshi_list/features/home/widgets/activity.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaInProgress = ref.watch(mediaInProgressProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          HorizontalList(items: mediaInProgress, title: "Anime In Progress"),
          SizedBox(height: 16),
          HorizontalList(items: mediaInProgress, title: "Manga In Progress"),
          SizedBox(height: 16),
          const ActivityTab(),
        ],
      ),
    );
  }
}
