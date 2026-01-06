import 'package:flutter/material.dart';
import 'package:hoshi_list/screens/home/anime.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Top tabs
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              tabs: [
                Tab(icon: null, text: 'Anime'),
                Tab(icon: null, text: 'Manga'),
              ],
            ),
          ),

          // Tab content
          const Expanded(
            child: TabBarView(
              children: [
                AnimeHomeScreen(),
                Center(child: Text('Manga Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
