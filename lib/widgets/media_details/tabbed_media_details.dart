import 'package:flutter/material.dart';

class TabbedMediaDetails extends StatelessWidget {
  const TabbedMediaDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Material(
            child: const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,

              tabs: [
                Tab(icon: Icon(Icons.info), text: 'Overview'),
                Tab(icon: Icon(Icons.list), text: 'Characters'),
                Tab(icon: Icon(Icons.person), text: 'Staff'),
                Tab(icon: Icon(Icons.bar_chart), text: 'Stats'),
                Tab(icon: Icon(Icons.reviews), text: 'Reviews'),
              ],
            ),
          ),

          const SizedBox(
            height: 400, // Fixed height for demonstration
            child: TabBarView(
              children: [
                Center(child: Text('Overview Content')),
                Center(child: Text('Characters Content')),
                Center(child: Text('Staff Content')),
                Center(child: Text('Stats Content')),
                Center(child: Text('Reviews Content')),
                // Add more tabs as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
