import 'package:flutter/material.dart';
import 'package:hoshi_list/features/home/home_screen.dart';
import 'package:hoshi_list/features/browse/browse_screen.dart';
import 'package:hoshi_list/features/mylist/list_screen.dart';
import 'package:hoshi_list/features/profile/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0; // Denotes the current select index in bottom nav bar

  // Method to create an animated icon switcher for navigation destinations
  Widget _animatedIconSwitcher(
    Icon selectedIcon,
    Icon unselectedIcon,
    bool isSelected,
  ) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
      child: isSelected ? selectedIcon : unselectedIcon,
    );
  }

  final List<Map<String, Map<String, dynamic>>> _tabScreens = [
    {
      'Home': {
        'screen': HomeScreen(),
        'selectedIcon': Icons.home,
        'unselectedIcon': Icons.home_outlined,
        'index': 0,
      },
    },
    {
      'Browse': {
        'screen': BrowseScreen(),
        'selectedIcon': Icons.search,
        'unselectedIcon': Icons.search_outlined,
        'index': 1,
      },
    },
    {
      'List': {
        'screen': ListScreen(),
        'selectedIcon': Icons.list,
        'unselectedIcon': Icons.list_alt,
        'index': 2,
      },
    },
    {
      'Profiles': {
        'screen': ProfileScreen(),
        'selectedIcon': Icons.person,
        'unselectedIcon': Icons.person_outline,
        'index': 3,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tabScreens[_selectedIndex].keys.first,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        scrolledUnderElevation: 0,
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _tabScreens
            .map((tab) => tab.values.first['screen'] as Widget)
            .toList(),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: _tabScreens.map((tab) {
          String title = tab.keys.first;
          var details = tab[title]!;

          return NavigationDestination(
            icon: _animatedIconSwitcher(
              Icon(details['selectedIcon'], key: ValueKey('selected_$title')),
              Icon(
                details['unselectedIcon'],
                key: ValueKey('unselected_$title'),
              ),
              details['index'] == _selectedIndex,
            ),
            label: title,
          );
        }).toList(),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
