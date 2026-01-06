import 'package:flutter/material.dart';
import 'package:hoshi_list/screens/browse.dart';
import 'package:hoshi_list/screens/home.dart';
import 'package:hoshi_list/screens/list.dart';
import 'package:hoshi_list/screens/profile.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0; // Denotes the current selectd index in bottom nav bar

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

  // Mapping of page identifiers to their respective screen widgets
  final Map<String, Widget> _pages = {
    'Home': HomeScreen(),
    'Browse': BrowseScreen(),
    'List': ListScreen(),
    'Profiles': ProfileScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages.keys.elementAt(_selectedIndex),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: _pages.values.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: _animatedIconSwitcher(
              Icon(Icons.home, key: ValueKey('selected')),
              Icon(Icons.home_outlined, key: ValueKey('unselected')),
              _selectedIndex == 0,
            ),
            selectedIcon: _animatedIconSwitcher(
              Icon(Icons.home, key: ValueKey('selected')),
              Icon(Icons.home_outlined, key: ValueKey('unselected')),
              _selectedIndex == 0,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: _animatedIconSwitcher(
              Icon(Icons.search, key: ValueKey('selected')),
              Icon(Icons.search_outlined, key: ValueKey('unselected')),
              _selectedIndex == 1,
            ),
            selectedIcon: _animatedIconSwitcher(
              Icon(Icons.search, key: ValueKey('selected')),
              Icon(Icons.search_outlined, key: ValueKey('unselected')),
              _selectedIndex == 1,
            ),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: _animatedIconSwitcher(
              Icon(Icons.list, key: ValueKey('selected')),
              Icon(Icons.list_alt, key: ValueKey('unselected')),
              _selectedIndex == 2,
            ),
            selectedIcon: _animatedIconSwitcher(
              Icon(Icons.list, key: ValueKey('selected')),
              Icon(Icons.list_alt, key: ValueKey('unselected')),
              _selectedIndex == 2,
            ),
            label: 'List',
          ),
          NavigationDestination(
            icon: _animatedIconSwitcher(
              Icon(Icons.person, key: ValueKey('selected')),
              Icon(Icons.person_outline, key: ValueKey('unselected')),
              _selectedIndex == 3,
            ),
            selectedIcon: _animatedIconSwitcher(
              Icon(Icons.person, key: ValueKey('selected')),
              Icon(Icons.person_outline, key: ValueKey('unselected')),
              _selectedIndex == 3,
            ),
            label: 'Profile',
          ),
        ],
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
