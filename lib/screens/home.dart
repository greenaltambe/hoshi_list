import 'package:flutter/material.dart';

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
                Center(child: Text('Anime Content')),
                Center(child: Text('Manga Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
